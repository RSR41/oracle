import { IsString, IsNotEmpty, IsBoolean, IsOptional, IsJSON } from 'class-validator';

export class SetupTagDto {
    @IsString()
    @IsNotEmpty()
    birthDate: string; // YYYY-MM-DD

    @IsString()
    @IsOptional()
    birthTime: string; // HH:mm

    @IsString()
    @IsNotEmpty()
    gender: string; // M/F

    @IsBoolean()
    isSolar: boolean;

    @IsBoolean()
    @IsOptional()
    isLeapMonth: boolean;

    @IsBoolean()
    @IsOptional()
    isUnknownTime: boolean;
}
