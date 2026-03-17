import 'package:hive_flutter/hive_flutter.dart';

import '../model/hive_entry.dart';

class HiveManager {
  static const _boxName = 'demo_box';
  static const _entryKey = 'saved_entry';

  Box<HiveEntry>? _box;

  bool get isReady => _box != null;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HiveEntryAdapter());
    _box = await Hive.openBox<HiveEntry>(_boxName);
  }

  Future<void> save({
    required String stringValue,
    required int numberValue,
  }) async {
    final entry = HiveEntry(
      stringValue: stringValue,
      numberValue: numberValue,
    );
    await _box?.put(_entryKey, entry);
  }

  HiveEntry? getEntry() {
    return _box?.get(_entryKey);
  }

  Future<void> deleteAll() async {
    await _box?.clear();
  }

  Future<void> dispose() async {
    await _box?.close();
    _box = null;
  }
}
