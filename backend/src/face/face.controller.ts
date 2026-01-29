import { Controller, Post, UseInterceptors, UploadedFile, UseGuards } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { FaceService } from './face.service';
import { AuthGuard } from '@nestjs/passport';

@Controller('face')
export class FaceController {
    constructor(private readonly faceService: FaceService) { }

    @UseGuards(AuthGuard('jwt'))
    @Post('analyze')
    @UseInterceptors(FileInterceptor('image'))
    analyze(@UploadedFile() file: any) { // Type check skipped for MVP
        return this.faceService.analyze(file);
    }
}
