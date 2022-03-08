import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicerr/bloc/additional_info_bloc/additional_info_cubit.dart';
import 'package:invoicerr/bloc/additional_info_bloc/additional_info_state.dart';
import 'package:invoicerr/bloc/hive_bloc/hive_cubit.dart';
import 'package:invoicerr/model/client_details.dart';
import 'package:invoicerr/model/invoice_model.dart';

class ClientDetailsPage extends StatefulWidget {
  @override
  _ClientDetailsPageState createState() => _ClientDetailsPageState();

  ClientDetails? details;
  InvoiceModel? model;

  ClientDetailsPage({this.details, this.model});
}

class _ClientDetailsPageState extends State<ClientDetailsPage> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController clientNameController;
  late TextEditingController clientNumberController;
  late TextEditingController companyNameController;
  late TextEditingController addressController1;
  late TextEditingController addressController2;
  late TextEditingController addressController3;


  @override
  void initState() {

    clientNameController = TextEditingController();
    clientNumberController = TextEditingController();
    companyNameController = TextEditingController();
    addressController1 = TextEditingController();
    addressController2 = TextEditingController();
    addressController3 = TextEditingController();

    if(widget.details != null){
      clientNameController.text = widget.details!.clientName;
      clientNumberController.text = widget.details!.clientNum;

      companyNameController.text = widget.details!.companyName;

      addressController1.text = widget.details!.companyAddress1;

      addressController2.text = widget.details!.companyAddress2;
      addressController3.text = widget.details!.companyAddress3;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Client Detail page",
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
                    fieldName: "Client name",
                    textFieldLabel: "Client name",
                    textFieldHintText: "Enter client name",
                    controller: clientNameController,
                    validate: true,
                    inputType: TextInputType.text
                ),
                buildClientInfo(
                    fieldName: "Client number",
                    textFieldLabel: "Client number",
                    textFieldHintText: "Enter client phone number",
                    controller: clientNumberController,
                    validate: true,
                    inputType: TextInputType.number
                ),
                buildClientInfo(
                    fieldName: "Company name",
                    textFieldLabel: "Company name",
                    textFieldHintText: "Enter company name",
                    controller: companyNameController,
                    validate: true,
                    inputType: TextInputType.text
                ),
                buildClientInfo(
                    fieldName: "Company Address Line 1",
                    textFieldLabel: "Company Address",
                    textFieldHintText: "Company Address",
                    controller: addressController1,
                    inputType: TextInputType.text
                ),
                buildClientInfo(
                    fieldName: "Company Address Line 2",
                    textFieldLabel: "Company Address",
                    textFieldHintText: "Company Address",
                    controller: addressController2,
                    inputType: TextInputType.text
                ),

                buildClientInfo(
                    fieldName: "Company Address Line 3",
                    textFieldLabel: "Company Address",
                    textFieldHintText: "Company Address",
                    controller: addressController3,
                    inputType: TextInputType.text
                ),
                const SizedBox(height: 10.0,),
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
                          "Save Details",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              letterSpacing: 5.0
                          ),
                        ),
                      ),
                      onPressed: (){
                        if(formKey.currentState!.validate()){
                          ClientDetails details = ClientDetails(
                            clientName: clientNameController.text,
                            clientNum: clientNumberController.text,
                            companyAddress1: addressController1.text,
                            companyAddress2: addressController2.text,
                            companyAddress3: addressController3.text,
                            companyName: companyNameController.text,
                          );



                          if(widget.model != null){
                            BlocProvider.of<HiveCubit>(context).updateInvoiceModel(
                              model: widget.model!,
                              clientDetails: details
                            );
                            BlocProvider.of<AdditionalInfoCubit>(context).addClientDetails(
                                details,
                                state,
                              widget.model
                            );
                          }else{
                            BlocProvider.of<AdditionalInfoCubit>(context).addClientDetails(
                                details,
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
            fieldName,
            style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
