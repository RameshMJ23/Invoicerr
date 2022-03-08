

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicerr/bloc/additional_info_bloc/additional_info_cubit.dart';
import 'package:invoicerr/bloc/additional_info_bloc/additional_info_state.dart';
import 'package:invoicerr/bloc/hive_bloc/hive_cubit.dart';
import 'package:invoicerr/model/invoice_model.dart';

class AdditionalNotesPage extends StatefulWidget {
  @override
  _AdditionalNotesPageState createState() => _AdditionalNotesPageState();

  String? notes;
  InvoiceModel? model;

  AdditionalNotesPage({this.notes, this.model});
}

class _AdditionalNotesPageState extends State<AdditionalNotesPage> {

  late TextEditingController notesController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    notesController = TextEditingController();

    if(widget.notes != null){
      notesController.text = widget.notes!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Additional notes",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              "Additional notes :",
              style: TextStyle(
                  fontSize: 20.0
              ),
            ),
          ),
          Container(
            height: 300.0,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (val) => val!.isEmpty ? "Enter notes" : null,
                  controller: notesController,
                  textAlignVertical: TextAlignVertical.top,
                  expands: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
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
                    hintText: "Add addtional notes",
                    hintStyle: TextStyle(
                        color: Colors.purple[400]
                    ),
                    label: const Text(
                      "Notes",
                      style: TextStyle(
                        color: Colors.purple,
                      ),
                      textAlign: TextAlign.start,
                    ),
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
              ),
            ),
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
                    "Add Note",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        letterSpacing: 5.0
                    ),
                  ),
                ),
                onPressed: (){
                  if(_formKey.currentState!.validate()){


                    if(widget.model != null){

                      BlocProvider.of<AdditionalInfoCubit>(context).addNotes(notesController.text, state, widget.model);

                      BlocProvider.of<HiveCubit>(context).updateInvoiceModel(
                       model: widget.model!,
                       additionalNote: notesController.text
                      );
                    }else{
                      BlocProvider.of<AdditionalInfoCubit>(context).addNotes(notesController.text, state, null);

                    }
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}
