import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/isar_entry.dart';

class IsarManager {
  Isar? _isar;

  bool get isReady => _isar != null;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [IsarEntrySchema],
      directory: dir.path,
    );
  }

  Future<void> save({
    required String stringValue,
    required int numberValue,
  }) async {
    final isar = _isar;
    if (isar == null) return;

    await isar.writeTxn(() async {
      await isar.isarEntrys.clear();
      final entry = IsarEntry()
        ..stringValue = stringValue
        ..numberValue = numberValue;
      await isar.isarEntrys.put(entry);
    });
  }

  IsarEntry? getEntry() {
    return _isar?.isarEntrys.where().findFirstSync();
  }

  Future<void> deleteAll() async {
    final isar = _isar;
    if (isar == null) return;
    await isar.writeTxn(() => isar.isarEntrys.clear());
  }

  Future<void> dispose() async {
    await _isar?.close();
    _isar = null;
  }
}
