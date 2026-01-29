import { Controller, Get, Post, Body, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { HistoryService } from './history.service';
import { CreateHistoryDto } from './dto/create-history.dto';
import { AuthGuard } from '@nestjs/passport';

@UseGuards(AuthGuard('jwt'))
@Controller('history')
export class HistoryController {
    constructor(private readonly historyService: HistoryService) { }

    @Post()
    create(@Request() req, @Body() createHistoryDto: CreateHistoryDto) {
        return this.historyService.create(req.user.id, createHistoryDto);
    }

    @Get()
    findAll(@Request() req) {
        return this.historyService.findAll(req.user.id);
    }

    @Delete(':id')
    remove(@Request() req, @Param('id') id: string) {
        return this.historyService.remove(req.user.id, id);
    }
}
