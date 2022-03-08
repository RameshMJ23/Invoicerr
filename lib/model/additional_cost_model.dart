
import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class AdditionalCost{
  
  @HiveField(41)
  String costName;
  
  @HiveField(42)
  double cost;
  
  AdditionalCost({
    required this.cost,
    required this.costName
  });
}