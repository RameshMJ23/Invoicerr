import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoicerr/bloc/add_items_bloc/add_item_cubit.dart';
import 'package:invoicerr/bloc/hive_bloc/hive_cubit.dart';
import 'package:invoicerr/bloc/hive_bloc/hive_state.dart';
import 'package:invoicerr/enums/bloc_enums.dart';
import 'package:invoicerr/model/additional_cost_model.dart';
import 'package:invoicerr/model/basic_info.dart';
import 'package:invoicerr/model/drop_down_model.dart';
import 'package:invoicerr/model/invoice_model.dart';
import 'package:invoicerr/model/item_model.dart';
import 'package:invoicerr/screens/basic_info_screen.dart';
import 'package:invoicerr/screens/create_invoice_page.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late Box<InvoiceModel> invoiceBox;
  late List<InvoiceModel> invoiceList;
  DateFormat dateFormat = DateFormat.yMd();

  List<DropDownModel> dropDownItems = [
    DropDownModel(optionName: "ALL", value: PaidFilter.all),
    DropDownModel(optionName:  "PAID", value: PaidFilter.paid),
    DropDownModel(optionName: "UNPAID", value: PaidFilter.unpaid),
  ];

  List<SortDropDownModel> sortDropDownItems = [
    SortDropDownModel(optionName: "ASC", sortValue: Sort.ascending),
    SortDropDownModel(optionName: "DES", sortValue: Sort.descending)
  ];


  @override
  void initState() {
    BlocProvider.of<HiveCubit>(context).getHive();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Invoicerr",
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 5.0
            ),
            textAlign: TextAlign.start,
          ),
          backgroundColor: Colors.purple,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight:  Radius.circular(10.0))
          ),
          toolbarHeight: 90.0,
          bottom: PreferredSize(
            child: BlocBuilder<HiveCubit, HiveState>(
              builder: (context, state){

                String currentValue;
                String currentSortValue;

                if(state is HiveDataState){
                  if(state.paidFilter == PaidFilter.paid){
                    currentValue = "PAID";
                  }else if(state.paidFilter == PaidFilter.unpaid){
                    currentValue = "UNPAID";
                  }else{
                    currentValue = "ALL";
                  }
                }else{
                  currentValue = 'ALL';
                }

                if(state is HiveDataState){
                  if(state.sortFilter == Sort.ascending){
                    currentSortValue = "ASC";
                  }else if(state.sortFilter == Sort.descending){
                    currentSortValue = "DES";
                  }else{
                    currentSortValue = "ASC";
                  }
                }else{
                  currentSortValue = 'ASC';
                }

                return Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Align(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          height: 55.0,
                          child: DropdownButtonFormField<String>(
                            style: TextStyle(
                                fontSize: 12.0
                            ),
                            itemHeight: 48.0,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: Colors.black, width: 5.0)
                              ),
                              fillColor: Colors.white,
                              filled: true,

                            ),
                            items: dropDownItems.map((item) =>
                                DropdownMenuItem<String>(
                                  child: Text(item.optionName, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
                                  value: item.optionName,
                                )
                            ).toList(),
                            onChanged: (val){
                              if(val == dropDownItems[0].optionName){
                                BlocProvider.of<HiveCubit>(context).paidFilter(dropDownItems[0].value, state);
                              }else if(val == dropDownItems[1].optionName){
                                BlocProvider.of<HiveCubit>(context).paidFilter(dropDownItems[1].value, state);
                              }else{
                                BlocProvider.of<HiveCubit>(context).paidFilter(dropDownItems[2].value, state);
                              }
                            },
                            value: currentValue,
                          ),
                          width: 110.0,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Align(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          height: 55.0,
                          child: DropdownButtonFormField<String>(
                            style: TextStyle(
                                fontSize: 12.0
                            ),
                            itemHeight: 48.0,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(color: Colors.black, width: 4.0),
                              ),
                              fillColor: Colors.white,
                              filled: true,

                            ),
                            items: sortDropDownItems.map((item) =>
                                DropdownMenuItem<String>(
                                  child: Text(item.optionName, style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
                                  value: item.optionName,
                                )
                            ).toList(),
                            onChanged: (val){
                              if(val == sortDropDownItems[0].optionName){
                                BlocProvider.of<HiveCubit>(context).sortFilter(sortDropDownItems[0].sortValue, state);
                              }else if(val == sortDropDownItems[1].optionName){
                                BlocProvider.of<HiveCubit>(context).sortFilter(sortDropDownItems[1].sortValue, state);
                              }else{
                                BlocProvider.of<HiveCubit>(context).sortFilter(sortDropDownItems[0].sortValue, state);
                              }
                            },
                            value: currentSortValue,
                          ),
                          width: 110.0,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    )
                  ],
                );
              },
            ),
            preferredSize: Size(
              40.0,40.0
            ),
          ),
          actions: [
            IconButton(
              tooltip: "Basic Info",
              onPressed: (){
                Hive.boxExists('basicInfo').then((value) async{
                  if(value){
                    Navigator.push(context, MaterialPageRoute(builder: (_) =>
                        BasicInfo(box : Hive.box('basicInfo'))));
                  }else{
                    Box<BasicInfoModel> box = await Hive.openBox('basicInfo');
                    Navigator.push(context, MaterialPageRoute(builder: (_) =>
                        BasicInfo(box : box)));
                  }
                });
              },
              icon: Icon(Icons.person)
            )
          ],
        ),
        body: BlocBuilder<HiveCubit, HiveState>(
          builder: (context, state){
            if(state is NoHiveState){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else if(state is HiveDataState){

              List<InvoiceModel> invoiceList = [];

              invoiceList = state.invoiceList;



              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index){

                        if(invoiceList.isEmpty ){
                          return const Center(
                            child: Text(
                              "No invoice",
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          );
                        }else{
                          return InkWell(
                            onTap: (){

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>
                                      CreateInvoice(
                                        invoiceModel: invoiceList[index],
                                      )
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.purple, width: 2.0),
                                    borderRadius: BorderRadius.circular(15.0)
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        alignment: Alignment.center,
                                        onPressed: (){
                                          showDialog(
                                              context: context,
                                              builder: (context){
                                                return AlertDialog(
                                                  content: const Text("Do you want to delete this invoice?"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: (){
                                                          BlocProvider.of<HiveCubit>(context).deleteInvoice(index);
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text(
                                                            "yes",
                                                            style: TextStyle(
                                                                color: Colors.black
                                                            )
                                                        )
                                                    ),
                                                    TextButton(
                                                        onPressed: (){
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text(
                                                          "no",
                                                          style: TextStyle(
                                                              color: Colors.black
                                                          ),
                                                        )
                                                    ),
                                                  ],
                                                );
                                              }
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.black87,
                                        )
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Invoice id : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.0
                                              ),
                                            ),
                                            Text(invoiceList[index].invoiceNumber.toString()),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            CircleAvatar(
                                              radius: 10.0,
                                              child: Center(
                                                child: Icon(
                                                  invoiceList[index].paid
                                                      ? Icons.check
                                                      : Icons.close,
                                                  color: Colors.white,
                                                  size: 15.0,
                                                ),
                                              ),
                                              backgroundColor: invoiceList[index].paid
                                                  ? Colors.purple
                                                  : Colors.black54,
                                            )
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "To: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.0
                                              ),
                                            ),
                                            invoiceList[index].clientDetail != null
                                                ? Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${invoiceList[index].clientDetail!.clientName},"),
                                                Text(invoiceList[index].clientDetail!.companyName)
                                              ],
                                            )
                                                : const Text(" - (not provided)")
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Created on : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.0
                                              ),
                                            ),
                                            Text(
                                                dateFormat.format(invoiceList[index].date)
                                            )
                                          ],
                                        )

                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Payment Amount",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                              getTotal(invoiceList[index]).toStringAsFixed(2)
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      itemCount: invoiceList.length,
                    ),
                  )
                ],
              );
            }else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ) ,
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add
          ),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreateInvoice()));
          },
          backgroundColor: Colors.purple,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  double getTotal(InvoiceModel invoiceModel){
    double discount = invoiceModel.totalDiscount ?? 0.0;
    double tax = invoiceModel.tax ?? 0.0;
    List<AdditionalCost> additionalCostList = invoiceModel.additionalCost;
    double totalCost = 0.0;
    double discountCost = 0.0;
    double taxCost = 0.0;
    double finalCost = 0.0;
    double totalAdditionalCost = 0.0;

    additionalCostList.map((cost) => totalAdditionalCost += cost.cost).toList();

    List<ItemModel> list = invoiceModel.items;

    list.map((item) => totalCost = totalCost + item.totalAmount).toList();

    discountCost = totalCost * (discount / 100);

    taxCost = totalCost * (tax / 100);

    finalCost = totalCost + taxCost - discountCost + totalAdditionalCost;

    return finalCost;
  }

  @override
  void dispose() {

    super.dispose();
  }
}
