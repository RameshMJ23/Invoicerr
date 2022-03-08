import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicerr/bloc/add_items_bloc/add_item_cubit.dart';
import 'package:invoicerr/bloc/add_items_bloc/add_item_state.dart';
import 'package:invoicerr/bloc/hive_bloc/hive_cubit.dart';
import 'package:invoicerr/bloc/hive_bloc/hive_state.dart';
import 'package:invoicerr/model/invoice_model.dart';
import 'package:invoicerr/model/item_model.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();

  AddItemState state;
  InvoiceModel? hiveModel;

  AddItemPage({
    required this.state,
    this.hiveModel
  });
}

class _AddItemPageState extends State<AddItemPage> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController itemNameController;
  late TextEditingController itemCostController;
  late TextEditingController itemNumberController;
  late TextEditingController taxController;
  late TextEditingController discountController;



  @override
  void initState() {
    itemNameController = TextEditingController();
    itemCostController = TextEditingController();
    itemNumberController = TextEditingController();
    taxController = TextEditingController();
    discountController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Add Item",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                buildItemInfo(
                    fieldName: "Item name",
                    textFieldLabel: "Item name",
                    textFieldHintText: "Enter Item name",
                    controller: itemNameController,
                    validate: true,
                  inputType: TextInputType.text
                ),
                buildItemInfo(
                    fieldName: "Item cost",
                    textFieldLabel: "Item cost",
                    textFieldHintText: "Enter Item cost",
                    controller: itemCostController,
                    validate: true,
                    inputType: TextInputType.number
                ),
                buildItemInfo(
                    fieldName: "Number of Items",
                    textFieldLabel: "No. of Items",
                    textFieldHintText: "Enter no. of Items",
                    controller: itemNumberController,
                    validate:  true,
                    inputType: TextInputType.number
                ),
                buildItemInfo(
                    fieldName: "Tax (%)",
                    textFieldLabel: "Tax",
                    textFieldHintText: "Enter tax(empty if no tax)",
                    controller: taxController,
                    inputType: TextInputType.number
                ),
                buildItemInfo(
                    fieldName: "Discount (%)",
                    textFieldLabel: "Discount",
                    textFieldHintText: "Enter discount(empty if no discount)",
                    controller: discountController,
                    inputType: TextInputType.number
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purple),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )
                      )
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Add Item",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          letterSpacing: 5.0
                      ),
                    ),
                  ),
                  onPressed: (){
                    if(formKey.currentState!.validate()){


                      BlocProvider.of<AddItemCubit>(context).addItem(
                          ItemModel(
                              itemName: itemNameController.text,
                              costPerUnit: double.parse( itemCostController.text),
                              tax: double.parse(taxController.text.isEmpty ? "0.0" : taxController.text),
                              totalAmount: totalAmount(
                                  itemNumber: double.parse(itemNumberController.text),
                                  itemCost: double.parse( itemCostController.text),
                                  tax: (taxController.text == null || taxController.text.isEmpty)? 0.0 : double.parse(taxController.text),
                                  discount: (discountController.text == null || discountController.text.isEmpty) ? 0.0 : double.parse(discountController.text)),
                              numberOfItems: double.parse(itemNumberController.text),
                              discount: discountController.text.isNotEmpty
                                  ? double.parse(discountController.text)
                                  : null
                          ),
                          widget.state
                      );
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItemInfo({
    required String fieldName,
    required String textFieldLabel,
    required String textFieldHintText,
    Widget? trailing,
    required TextEditingController? controller,
    bool validate = false,
    required TextInputType inputType
  }){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.0),
      child: Column(
        children: [
          Text(
            "$fieldName",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              keyboardType: inputType,
              validator: (val){
                if(validate){
                  return val!.isEmpty
                    ? "required field"
                    : null;
                }else{
                  return null;
                }
              },
              controller: controller,
              decoration: InputDecoration(
                errorStyle: const TextStyle(
                    color: Colors.black
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.red, width: 2.0)
                ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.red, width: 2.0)
                ),
                hintText: textFieldHintText,
                hintStyle: TextStyle(
                    color: Colors.purple[400]
                ),
                label: Text(textFieldLabel, style: const TextStyle(color: Colors.purple)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.purple, width: 2.0)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.purple, width: 2.0)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.purple, width: 2.0)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  double totalAmount({
    required double itemNumber,
    required double itemCost,
    required double tax,
    required double discount
  }){
    double totalCost = itemCost * itemNumber;

    double taxAmount = totalCost * (tax/100);

    double discountAmount = totalCost * (discount/100);

    return totalCost + taxAmount - discountAmount;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
