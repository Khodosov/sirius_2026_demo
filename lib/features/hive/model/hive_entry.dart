import 'package:hive/hive.dart';

part 'hive_entry.g.dart';

@HiveType(typeId: 0)
class HiveEntry extends HiveObject {
  @HiveField(0)
  final String stringValue;

  @HiveField(1)
  final int numberValue;

  HiveEntry({
    required this.stringValue,
    required this.numberValue,
  });
}
