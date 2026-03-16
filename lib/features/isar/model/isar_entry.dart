import 'package:isar/isar.dart';

part 'isar_entry.g.dart';

@collection
class IsarEntry {
  Id id = Isar.autoIncrement;

  late String stringValue;

  late int numberValue;
}
