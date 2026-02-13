import '../database/history_repository.dart';
import '../models/fortune_result.dart';

/// Backward-compatible service that now delegates to SQLite history storage.
class FortuneService {
  final HistoryRepository _historyRepository = HistoryRepository();

  Future<void> save(FortuneResult result) =>
      _historyRepository.saveWithPayload(result: result);

  Future<List<FortuneResult>> getAll() =>
      _historyRepository.getAll(type: 'fortune');

  Future<void> clearAll() async {
    final all = await _historyRepository.getAll(type: 'fortune');
    for (final item in all) {
      await _historyRepository.delete(item.id);
    }
  }
}
