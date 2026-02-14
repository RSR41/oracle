import { Test, TestingModule } from '@nestjs/testing';
import { HistoryService } from './history.service';
import { HISTORY_REPOSITORY } from '../repository/repository.tokens';

describe('HistoryService', () => {
  let service: HistoryService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        HistoryService,
        {
          provide: HISTORY_REPOSITORY,
          useValue: {
            create: jest.fn(),
            findAllByUserId: jest.fn(),
            findById: jest.fn(),
            deleteById: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<HistoryService>(HistoryService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
