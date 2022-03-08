
import 'package:hive/hive.dart';

@HiveType(typeId:5)
class ClientDetails{

  @HiveField(50)
  String clientName;

  @HiveField(51)
  String clientNum;

  @HiveField(52)
  String companyName;

  @HiveField(53)
  String companyAddress1;

  @HiveField(54)
  String companyAddress2;

  @HiveField(55)
  String companyAddress3;

  ClientDetails({
    required this.clientName,
    required this.clientNum,
    required this.companyAddress1,
    required this.companyAddress2,
    required this.companyAddress3,
    required this.companyName
  });
}