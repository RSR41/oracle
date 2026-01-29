import { IsString, IsNotEmpty, IsOptional, IsJSON } from 'class-validator';

export class CreateHistoryDto {
    @IsString()
    @IsNotEmpty()
    type: string; // SAJU, TAROT, FACE, COMPATIBILITY

    @IsString()
    @IsNotEmpty()
    title: string;

    @IsString()
    @IsNotEmpty()
    summary: string;

    @IsOptional()
    metadata: any; // JSON
}
