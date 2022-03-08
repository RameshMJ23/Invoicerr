
import 'package:hive/hive.dart';

@HiveType(typeId: 6)
class DeliveryAddress{

  @HiveField(60)
  String receiverName;

  @HiveField(61)
  String receiverNum;

  @HiveField(62)
  String receiverAddress1;

  @HiveField(63)
  String receiverAddress2;

  @HiveField(64)
  String receiverAddress3;

  DeliveryAddress({
    required this.receiverName,
    required this.receiverNum,
    required this.receiverAddress1,
    required this.receiverAddress2,
    required this.receiverAddress3,
  });
}