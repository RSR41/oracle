import { IsString, IsNotEmpty } from 'class-validator';

export class CreateTransferDto {
    // Logic: Generating code doesn't require input body usually, maybe just confirmation
}

export class AcceptTransferDto {
    @IsString()
    @IsNotEmpty()
    code: string;
}
