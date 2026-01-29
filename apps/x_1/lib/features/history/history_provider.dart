import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:x_1/shared/domain/models/history.dart';
import 'package:x_1/shared/data/local/history_repository.dart';

part 'history_provider.g.dart';

@riverpod
class HistoryNotifier extends _$HistoryNotifier {
  @override
  FutureOr<List<History>> build() async {
    final repo = ref.read(historyRepositoryProvider);
    return repo.getHistory();
  }

  Future<void> addHistory(History item) async {
    final repo = ref.read(historyRepositoryProvider);
    await repo.saveHistory(item);
    // Reload
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteHistory(String id) async {
    final repo = ref.read(historyRepositoryProvider);
    await repo.deleteHistory(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> clearAll() async {
    final repo = ref.read(historyRepositoryProvider);
    await repo.clearHistory();
    ref.invalidateSelf();
    await future;
  }
}
