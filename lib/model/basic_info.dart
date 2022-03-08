
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class BasicInfoModel{

  @HiveField(1)
  String name;
  @HiveField(2)
  String companyName;
  @HiveField(3)
  String addressL1;
  @HiveField(4)
  String addressL2;
  @HiveField(5)
  String addressL3;
  @HiveField(6)
  String contactNo;
  @HiveField(7)
  String email;

  BasicInfoModel({
    required this.name,
    required this.email,
    required this.companyName,
    required this.addressL1,
    required this.addressL2,
    required this.addressL3,
    required this.contactNo
  });
}