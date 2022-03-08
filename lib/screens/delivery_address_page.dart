import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicerr/bloc/additional_info_bloc/additional_info_cubit.dart';
import 'package:invoicerr/bloc/additional_info_bloc/additional_info_state.dart';
import 'package:invoicerr/bloc/hive_bloc/hive_cubit.dart';
import 'package:invoicerr/model/delivery_address_model.dart';
import 'package:invoicerr/model/invoice_model.dart';

class DeliveryAddressPage extends StatefulWidget {
  @override
  _DeliveryAddressPageState createState() => _DeliveryAddressPageState();

  DeliveryAddress? address;
  InvoiceModel? model;

  DeliveryAddressPage({this.address, this.model});
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController clientNameController;
  late TextEditingController clientNumberController;
  late TextEditingController addressController1;
  late TextEditingController addressController2;
  late TextEditingController addressController3;


  @override
  void initState() {

    clientNameController = TextEditingController();
    clientNumberController = TextEditingController();
    addressController1 = TextEditingController();
    addressController2 = TextEditingController();
    addressController3 = TextEditingController();

    if(widget.address != null){
      clientNameController.text = widget.address!.receiverName;

      clientNumberController.text = widget.address!.receiverNum;

      addressController1.text = widget.address!.receiverAddress1;

      addressController2.text = widget.address!.receiverAddress2;

      addressController3.text = widget.address!.receiverAddress3;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Delivery address",
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
                buildClientInfo(
                    fieldName: "Receiver name",
                    textFieldLabel: "Receiver name",
                    textFieldHintText: "Enter receiver name",
                    controller: clientNameController,
                    validate: true,
                    inputType: TextInputType.text
                ),
                buildClientInfo(
                    fieldName: "Receiver number",
                    textFieldLabel: "Receiver number",
                    textFieldHintText: "Enter receiver phone number",
                    controller: clientNumberController,
                    validate: true,
                    inputType: TextInputType.number
                ),
                buildClientInfo(
                    fieldName: "Delivery Address Line 1",
                    textFieldLabel: "Delivery Address",
                    textFieldHintText: "Delivery Address",
                    controller: addressController1,
                    inputType: TextInputType.text
                ),
                buildClientInfo(
                    fieldName: "Delivery Address Line 2",
                    textFieldLabel: "Delivery Address",
                    textFieldHintText: "Delivery Address",
                    controller: addressController2,
                    inputType: TextInputType.text
                ),

                buildClientInfo(
                    fieldName: "Delivery Address Line 3",
                    textFieldLabel: "Delivery Address",
                    textFieldHintText: "Delivery Address",
                    controller: addressController3,
                    inputType: TextInputType.text
                ),
                const SizedBox(
                  height: 10.0,
                ),
                BlocBuilder<AdditionalInfoCubit, AdditionalInfoState>(
                  builder: (context, state){
                    return ElevatedButton(
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
                          "Add Address",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              letterSpacing: 5.0
                          ),
                        ),
                      ),
                      onPressed: (){
                        if(formKey.currentState!.validate()){

                          DeliveryAddress address = DeliveryAddress(
                              receiverName: clientNameController.text,
                              receiverNum: clientNumberController.text,
                              receiverAddress1: addressController1.text,
                              receiverAddress2: addressController2.text,
                              receiverAddress3: addressController3.text
                          );

                          if(widget.model != null){
                            BlocProvider.of<HiveCubit>(context).updateInvoiceModel(
                                model: widget.model!,
                                deliveryAddress: address
                            );
                            BlocProvider.of<AdditionalInfoCubit>(context).addDeliveryAddress(
                                address,
                                state,
                                widget.model
                            );
                          }else{
                            BlocProvider.of<AdditionalInfoCubit>(context).addDeliveryAddress(
                                address,
                                state,
                                null
                            );

                          }

                          Navigator.pop(context);
                        }
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildClientInfo({
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
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
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
}
