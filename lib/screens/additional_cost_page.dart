
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicerr/bloc/additional_costs_bloc/addtional_cost_cubit.dart';
import 'package:invoicerr/bloc/additional_costs_bloc/addtional_cost_state.dart';
import 'package:invoicerr/bloc/hive_bloc/hive_cubit.dart';
import 'package:invoicerr/model/additional_cost_model.dart';
import 'package:invoicerr/model/invoice_model.dart';

class AdditionalCostPage extends StatefulWidget {
  @override
  _AdditionalCostPageState createState() => _AdditionalCostPageState();

  InvoiceModel? model;

  AdditionalCostPage({this.model});

}

class _AdditionalCostPageState extends State<AdditionalCostPage> {

  late TextEditingController costNameController;
  late TextEditingController costValueController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    costNameController = TextEditingController();
    costValueController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Additional cost",
          style: TextStyle(
              color: Colors.white
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
        ),
        backgroundColor: Colors.purple,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildAdditionalInfo(
                fieldName: "Addtional cost",
                textFieldLabel: "Addtional cost",
                textFieldHintText: "Enter name of cost (eg.shipping)",
                controller: costNameController,
                inputType: TextInputType.text
            ),
            buildAdditionalInfo(
                fieldName: "Cost",
                textFieldLabel: "Cost",
                textFieldHintText: "Enter cost",
                controller: costValueController,
                inputType: TextInputType.number
            ),
            BlocBuilder<AdditionalCostCubit, AdditionalCostState>(
                builder: (context, state){
                  return Center(
                    child: ElevatedButton(
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
                          "Add cost",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              letterSpacing: 5.0
                          ),
                        ),
                      ),
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          BlocProvider.of<AdditionalCostCubit>(context).addCost(
                              AdditionalCost(
                                  cost: double.parse(costValueController.text),
                                  costName: costNameController.text
                              ),
                              state
                          );

                          costValueController.text = '';
                          costNameController.text = '';
                          if(widget.model != null){

                            List<AdditionalCost> costList;

                            if(state is InitAdditionalCostState){
                              costList = state.additionalCost;
                            }else if(state is AddedAdditionalCost){
                              costList = state.additionalCostList;
                            }else{
                              costList = [];
                            }

                            BlocProvider.of<HiveCubit>(context).updateInvoiceModel(
                              model: widget.model!,
                              additionalCost: costList
                            );
                          }
                        }
                      },
                    ),
                  );
                }
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0,top: 15.0),
              child:  Text(
                "Additional costs :",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,

                ),
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: BlocBuilder<AdditionalCostCubit, AdditionalCostState>(
                builder: (context, state){
                  List<AdditionalCost> list = [];
                  if(state is InitAdditionalCostState){
                    list = state.additionalCost;
                  }else if(state is AddedAdditionalCost){
                    list = state.additionalCostList;
                  }else if(state is EmptyListState){
                    list = [];
                  }

                  return ListView.builder(
                    itemBuilder: (context, index){
                      return ListTile(
                        title: Text(list[index].costName.toString()),
                        subtitle: Text(list[index].cost.toString()),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: (){
                            BlocProvider.of<AdditionalCostCubit>(context).deleteCost(state, index);
                          },
                        ),
                      );
                    },
                    itemCount: list.length,
                  );
                },
              ),
            )
          ],
        ),

      ),
    );
  }


  Widget buildAdditionalInfo({
    required String fieldName,
    required String textFieldLabel,
    required String textFieldHintText,
    Widget? trailing,
    required TextEditingController? controller,
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
              validator: (val) => val!.isEmpty ? "Required field" : null,
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
