
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoicerr/model/basic_info.dart';
import 'package:invoicerr/screens/main_page.dart';

class BasicInfo extends StatefulWidget {
  @override
  _BasicInfoState createState() => _BasicInfoState();

  Box<BasicInfoModel> box;

  BasicInfo({required this.box});
}

class _BasicInfoState extends State<BasicInfo> {

  late GlobalKey<FormState> formKey;

  late TextEditingController nameController;
  late TextEditingController companyNameController;
  late TextEditingController addressLine1;
  late TextEditingController addressLine2;
  late TextEditingController addressLine3;
  late TextEditingController contactNumberController;
  late TextEditingController emailController;


  @override
  void initState(){

    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    companyNameController = TextEditingController();
    addressLine1 = TextEditingController();
    addressLine2 = TextEditingController();
    addressLine3 = TextEditingController();
    contactNumberController = TextEditingController();
    emailController = TextEditingController();

    if(widget.box.containsKey('userInfo')){

      BasicInfoModel boxValue = widget.box.get('userInfo')!;
      nameController.text = boxValue.name;
      companyNameController.text = boxValue.companyName;
      addressLine1.text = boxValue.addressL1;
      addressLine2.text = boxValue.addressL2;
      addressLine3.text = boxValue.addressL3;
      contactNumberController.text = boxValue.contactNo;
      emailController.text = boxValue.email;
    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.purple,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Basic Info",
            style: TextStyle(
              color: Colors.white,
              wordSpacing: 5.0,
              letterSpacing: 3.0
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textFieldWidget("Name", "Name of owner", nameController),
                  textFieldWidget("Company name", "Name of Company", companyNameController),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                        "Company Address :",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                  textFieldWidget("Line 1", "Address of company", addressLine1),
                  textFieldWidget("Line 2", "Address of company", addressLine2),
                  textFieldWidget("Line 3", "Address of company", addressLine3),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                        "Contact Information :",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600
                        )
                    ),
                  ),
                  textFieldWidget("Contanct no.", "Enter contanct number", contactNumberController),
                  textFieldWidget("Email", "Enter email", emailController),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )
                        )
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 22.0,
                          letterSpacing: 5.0
                        ),
                      ),
                    ),
                    onPressed: (){
                      if(formKey.currentState!.validate()){
                        widget.box.put(
                          "userInfo",
                          BasicInfoModel(
                            name: nameController.text,
                            email: emailController.text,
                            companyName: companyNameController.text,
                            addressL1: addressLine1.text,
                            addressL2: addressLine2.text,
                            addressL3: addressLine3.text,
                            contactNo: contactNumberController.text,
                          )
                        );

                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainPage()), (Route<dynamic> route) => false,);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textFieldWidget(
      String label,
      String hintText,
      TextEditingController controller
  ){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        validator: (val) => val!.isEmpty ? "Enter value" : null,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            color: Colors.black
          ),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.white, width: 2.0)
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.black, width: 2.0)
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
              color: Colors.white70
          ),
          label: Text(label, style: const TextStyle(color: Colors.white)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.white, width: 2.0)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.white, width: 2.0)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.white, width: 2.0)
          ),
        ),
      ),
    );
  }
}
