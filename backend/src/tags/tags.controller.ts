import { Controller, Get, Post, Body, Param, UseGuards, Request } from '@nestjs/common';
import { TagsService } from './tags.service';
import { SetupTagDto } from './dto/setup-tag.dto';
import { AcceptTransferDto } from './dto/transfer-tag.dto';
import { AuthGuard } from '@nestjs/passport';

@Controller()
export class TagsController {
    constructor(private readonly tagsService: TagsService) { }

    // --- Public Routes ---

    @Get('public/tags/:tagId')
    getPublicSummary(@Param('tagId') tagId: string) {
        return this.tagsService.getPublicSummary(tagId);
    }

    @Post('public/tags/:tagId/setup')
    setupInitialData(@Param('tagId') tagId: string, @Body() dto: SetupTagDto) {
        return this.tagsService.setupInitialData(tagId, dto);
    }

    // --- Protected Routes (App) ---

    @UseGuards(AuthGuard('jwt'))
    @Post('tags/:tagId/claim')
    claimTag(@Request() req, @Param('tagId') tagId: string) {
        return this.tagsService.claimTag(req.user.id, tagId);
    }

    @UseGuards(AuthGuard('jwt'))
    @Post('tags/:tagId/transfer')
    createTransfer(@Request() req, @Param('tagId') tagId: string) {
        return this.tagsService.createTransfer(req.user.id, tagId);
    }

    @UseGuards(AuthGuard('jwt'))
    @Post('tags/transfer/accept')
    acceptTransfer(@Request() req, @Body() dto: AcceptTransferDto) {
        return this.tagsService.acceptTransfer(req.user.id, dto);
    }
}
