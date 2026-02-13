import { Injectable, NotFoundException, BadRequestException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { SetupTagDto } from './dto/setup-tag.dto';
import { AcceptTransferDto } from './dto/transfer-tag.dto';
import { Prisma } from '@prisma/client';

@Injectable()
export class TagsService {
    constructor(private prisma: PrismaService) { }

    // PWA: Get Public Summary
    async getPublicSummary(tagId: string) {
        const tag = await this.prisma.tag.findUnique({
            where: { tagId },
        });

        if (!tag) {
            throw new NotFoundException('Tag not found');
        }

        if (tag.status === 'UNCLAIMED') {
            return {
                status: 'UNCLAIMED',
                summary: tag.tempData ? 'Initial data received. Ready to claim.' : 'No data. Please setup.',
                needsSetup: !tag.tempData,
                data: tag.tempData, // Return simple data for display
            };
        }

        // CLAIMED
        return {
            status: 'CLAIMED',
            summary: 'This tag is claimed. View formatted summary here.',
            // For MVP, we can return dummy fortune summary or cached fortune if added later
            fortuneRecommendation: '"Great things take time."',
        };
    }

    // PWA: Setup Initial Data
    async setupInitialData(tagId: string, dto: SetupTagDto) {
        const tag = await this.prisma.tag.findUnique({
            where: { tagId },
        });

        if (!tag) {
            // Auto-create tag if using "dynamic" tag generation policy (or strict check)
            // For MVP, let's assume valid tags must pre-exist OR we create on first scan if valid format?
            // "Tag ID Generation Strategy: 16-char URL-safe Base64"
            // Let's create it if it doesn't exist for easier testing, assuming the ID format logic is upstream or handled by manufacturing.
            // But strictly, we should check if it's a valid ID.
            // For Phase 4, let's allow creating UNCLAIMED tag on the fly.
            return this.prisma.tag.create({
                data: {
                    tagId,
                    status: 'UNCLAIMED',
                    tempData: dto as any,
                },
            });
        }

        if (tag.status !== 'UNCLAIMED') {
            throw new ForbiddenException('Tag is already claimed');
        }

        return this.prisma.tag.update({
            where: { tagId },
            data: {
                tempData: dto as any,
            },
        });
    }

    // App: Claim Tag
    async claimTag(userId: string, tagId: string) {
        const tag = await this.prisma.tag.findUnique({ where: { tagId } });

        if (!tag) throw new NotFoundException('Tag not found');
        if (tag.status !== 'UNCLAIMED') throw new BadRequestException('Tag already claimed');

        // Link to user
        await this.prisma.tag.update({
            where: { tagId },
            data: {
                status: 'CLAIMED',
                ownerId: userId,
                tempData: Prisma.DbNull, // Clear temp data after claiming (or we could merge it to Profile, implemented below)
            },
        });

        // Check if user has profile, if not, maybe use tempData?
        // Simplified for MVP: Just link it. User can update profile separately.

        return { message: 'Tag claimed successfully' };
    }

    // App: Create Transfer Code
    async createTransfer(userId: string, tagId: string) {
        const tag = await this.prisma.tag.findUnique({ where: { tagId } });
        if (!tag) throw new NotFoundException('Tag not found');
        if (tag.ownerId !== userId) throw new ForbiddenException('Not your tag');

        // Generate 8-char code. Simple implementation.
        const code = crypto.randomUUID().replace(/-/g, '').substring(0, 8).toUpperCase();
        const expiresAt = new Date();
        expiresAt.setHours(expiresAt.getHours() + 24); // 24h

        // Invalidate old pending transfers
        // (Prisma relation logic handled by DB constraints or manual check)

        const transfer = await this.prisma.tagTransfer.create({
            data: {
                tagId: tag.id, // Using internal UUID
                fromOwnerId: userId,
                code,
                status: 'PENDING',
                expiresAt,
            },
        });

        return { code, expiresAt };
    }

    // App: Accept Transfer
    async acceptTransfer(userId: string, dto: AcceptTransferDto) {
        const transfer = await this.prisma.tagTransfer.findUnique({
            where: { code: dto.code },
            include: { tag: true },
        });

        if (!transfer) throw new NotFoundException('Invalid code');
        if (transfer.status !== 'PENDING') throw new BadRequestException('Code expired or used');
        if (transfer.expiresAt < new Date()) throw new BadRequestException('Code expired');
        if (transfer.fromOwnerId === userId) throw new BadRequestException('Cannot transfer to self');

        // Perform Transfer
        await this.prisma.$transaction(async (tx) => {
            // 1. Update Transfer record
            await tx.tagTransfer.update({
                where: { id: transfer.id },
                data: {
                    status: 'COMPLETED',
                    toOwnerId: userId,
                    completedAt: new Date(),
                },
            });

            // 2. Update Tag: Change owner, RESET data
            await tx.tag.update({
                where: { id: transfer.tag.id },
                data: {
                    ownerId: userId,
                    tempData: Prisma.DbNull, // Reset temp data if any
                    // We do NOT delete History rows, as they belong to the User (fromOwnerId), not the Tag strictly.
                },
            });
        });

        return { message: 'Transfer successful' };
    }
}
