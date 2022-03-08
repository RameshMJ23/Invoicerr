import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class ItemModel{

  @HiveField(14)
  String itemName;

  @HiveField(15)
  double costPerUnit;

  @HiveField(16)
  double tax;

  @HiveField(17)
  double totalAmount;

  @HiveField(18)
  String? notes;

  @HiveField(19)
  double numberOfItems;

  @HiveField(20)
  double? discount;

  ItemModel({
    required this.itemName,
    required this.costPerUnit,
    required this.tax,
    required this.totalAmount,
    this.notes,
    this.discount,
    required this.numberOfItems
  });
}