import 'package:oracle_flutter/app/database/history_repository.dart';
import 'package:oracle_flutter/app/models/fortune_result.dart';

/// SQLite-backed fortune history service.
///
/// Legacy call sites can continue using [FortuneService], but all persistence
/// is delegated to [HistoryRepository] so history is unified in SQLite.
class FortuneService {
  final HistoryRepository _historyRepository;

  FortuneService({HistoryRepository? historyRepository})
    : _historyRepository = historyRepository ?? HistoryRepository();

  Future<void> save(FortuneResult result) {
    return _historyRepository.save(result);
  }

  Future<List<FortuneResult>> getAll() {
    return _historyRepository.getAll(type: 'fortune');
  }

  Future<void> clearAll() async {
    final items = await _historyRepository.getAll(type: 'fortune');
    for (final item in items) {
      await _historyRepository.delete(item.id);
    }
  }
}
