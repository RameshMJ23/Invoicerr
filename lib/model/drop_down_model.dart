
import 'package:invoicerr/enums/bloc_enums.dart';

class DropDownModel{

  String optionName;

  PaidFilter value;

  DropDownModel({required this.optionName,required this.value});
}

class SortDropDownModel{

  String optionName;

  Sort sortValue;

  SortDropDownModel({required this.optionName,required this.sortValue});
}