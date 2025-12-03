import 'package:hive_ce/hive.dart';

// part 'inclinometer_row.g.dart';

@HiveType(typeId: 1)
class InclinometerRow extends HiveObject {
  @HiveField(0)
  double? depth;

  @HiveField(0)
  double? aPlus;

  @HiveField(0)
  double? aMinus;

  @HiveField(0)
  double? bPlus;

  @HiveField(0)
  double? bMinus;

  InclinometerRow({
    this.depth,
    this.aPlus,
    this.aMinus,
    this.bPlus,
    this.bMinus,

  });
}