
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoicerr/bloc/Net_detail_bloc/net_detail_cubit.dart';
import 'package:invoicerr/bloc/Net_detail_bloc/net_detail_state.dart';
import 'package:invoicerr/bloc/add_items_bloc/add_item_cubit.dart';
import 'package:invoicerr/bloc/add_items_bloc/add_item_state.dart';
import 'package:invoicerr/bloc/additional_costs_bloc/addtional_cost_cubit.dart';
import 'package:invoicerr/bloc/additional_costs_bloc/addtional_cost_state.dart';
import 'package:invoicerr/bloc/additional_info_bloc/additional_info_cubit.dart';
import 'package:invoicerr/bloc/additional_info_bloc/additional_info_state.dart';
import 'package:invoicerr/bloc/hive_bloc/hive_cubit.dart';
import 'package:invoicerr/bloc/pdf_creater/pdf_creater.dart';
import 'package:invoicerr/model/additional_cost_model.dart';
import 'package:invoicerr/model/basic_info.dart';
import 'package:invoicerr/model/client_details.dart';
import 'package:invoicerr/model/delivery_address_model.dart';
import 'package:invoicerr/model/invoice_model.dart';
import 'package:invoicerr/model/item_model.dart';
import 'package:invoicerr/screens/add_item_page.dart';
import 'package:invoicerr/screens/additional_cost_page.dart';
import 'package:invoicerr/screens/additional_notes_page.dart';
import 'package:invoicerr/screens/basic_info_screen.dart';
import 'package:invoicerr/screens/client_details.dart';
import 'package:invoicerr/screens/delivery_address_page.dart';
import 'package:invoicerr/screens/edit_item_page.dart';
import 'package:flutter_switch/flutter_switch.dart';


class CreateInvoice extends StatefulWidget {
  @override
  _CreateInvoiceState createState() => _CreateInvoiceState();

  InvoiceModel? invoiceModel;

  CreateInvoice({this.invoiceModel});
}

class _CreateInvoiceState extends State<CreateInvoice> {

  Box<InvoiceModel> invoiceBox = Hive.box('invoicebox');
  late TextEditingController netTaxController;
  late TextEditingController netDiscountController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    netTaxController = TextEditingController();
    netDiscountController = TextEditingController();

    if(widget.invoiceModel != null){

      InvoiceModel model = widget.invoiceModel!;

      BlocProvider.of<AddItemCubit>(context).updateCreatedInvoice(model.items);

      BlocProvider.of<AdditionalInfoCubit>(context).updateInvoice(
        notes: model.notes,
        clientDetails: model.clientDetail,
        address: model.deliveryAddress,
        paid: model.paid
      );
      BlocProvider.of<AdditionalCostCubit>(context).updateInvoice(model.additionalCost);


      BlocProvider.of<NetDetailCubit>(context).updateInvoice(model.totalDiscount, model.tax);
    }

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop:  _onWillPop,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              widget.invoiceModel == null ? "Create Invoice" : "Update Invoice",
              style: const TextStyle(
                  color: Colors.white
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            backgroundColor: Colors.purple,
            actions: widget.invoiceModel != null ? [
                IconButton(
                  tooltip: "generate pdf",
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: () {
                    Hive.boxExists('basicInfo').then((value) async{
                      if(value && Hive.box<BasicInfoModel>('basicInfo').get('userInfo') != null){
                        final pdf = await PdfCreator.createInvoice(widget.invoiceModel!.invoiceNumber, widget.invoiceModel!);

                        PdfCreator.savePdf("invoice", pdf);
                      }else{
                        showNotification(context);
                      }
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 7.0
                  ),
                  child: BlocBuilder<AdditionalInfoCubit, AdditionalInfoState>(
                    builder: (context, state){

                      bool paid;
                      if(state is AddedAdditionalInfo){
                        paid = state.paid;
                      }else{
                        paid = false;
                      }

                      return switcherWidget(
                        state: paid,
                        cubitState: state
                      );
                    },
                  )
                )
              ]
              : [SizedBox()],
          ),
          body: BlocBuilder<AddItemCubit, AddItemState>(

            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shopping_cart, size: 20.0,),
                          const SizedBox(width: 5.0,),
                          const Text(
                              "List of Items",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20.0
                              )
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (_) {
                                return BlocBuilder<AddItemCubit, AddItemState>(
                                    builder: (context, state) => widget.invoiceModel != null
                                        ? AddItemPage(state: state, hiveModel: widget.invoiceModel,)
                                        : AddItemPage(state: state)
                                );
                              }));
                            },
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.purple),
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 400.0,
                        child: BlocBuilder<AddItemCubit, AddItemState>(
                            builder: (context, state) {
                              late List<ItemModel> itemList;

                              if (state is InitItemState) {
                                itemList = state.initItems;
                              } else if (state is ItemAddedState) {
                                itemList = state.items;
                              }


                              if (itemList.isEmpty) {
                                return const Center(
                                    child: Text("No items added",
                                      style: TextStyle(color: Colors.black),)
                                );
                              }

                              return Column(
                                children: [
                                  Expanded(
                                    child: ListView.separated(
                                      itemBuilder: (context, index) {


                                        if(widget.invoiceModel != null){
                                          BlocProvider.of<HiveCubit>(context).updateInvoiceModel(
                                              model: widget.invoiceModel!,
                                              items: itemList
                                          );
                                        }
                                        if (itemList.isEmpty) {
                                          return Center(
                                            child: Container(
                                              color: Colors.green,
                                              child: const Text("No items selected",
                                                style: TextStyle(
                                                    color: Colors.black),),
                                            ),
                                          );
                                        } else {
                                          return InkWell(
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(
                                                  vertical: 3.0, horizontal: 5.0),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                content: const Text(
                                                                    "Do you want to delete this item?"
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed: () {

                                                                        if(widget.invoiceModel != null){
                                                                          List<ItemModel> itemList = [];

                                                                          if(state is ItemAddedState){
                                                                            itemList = state.items;
                                                                          }else if(state is InitItemState){
                                                                            itemList = state.initItems;
                                                                          }

                                                                          if(itemList.length <= 1){
                                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                                              SnackBar(
                                                                                behavior: SnackBarBehavior.floating,
                                                                                content: const Text(
                                                                                  "List of Items cannot be empty!",
                                                                                  style: TextStyle(
                                                                                      color: Colors.white
                                                                                  ),
                                                                                ),
                                                                                backgroundColor: Colors.purple,
                                                                              ),
                                                                            );
                                                                          }else{
                                                                            BlocProvider.of<AddItemCubit>(context).removeItem(
                                                                                index,
                                                                                state
                                                                            );
                                                                          }
                                                                        }else{
                                                                          BlocProvider.of<AddItemCubit>(context).removeItem(
                                                                              index,
                                                                              state
                                                                          );
                                                                        }

                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: const Text(
                                                                          "yes"
                                                                      )
                                                                  ),
                                                                  TextButton(
                                                                      onPressed: () {
                                                                        Navigator
                                                                            .pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          "No"
                                                                      )
                                                                  )
                                                                ],
                                                              );
                                                            }
                                                        );
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        size: 25.0,
                                                      )
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              itemList[index]
                                                                  .itemName
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight
                                                                      .w600
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Text(itemList[index]
                                                                .numberOfItems
                                                                .toStringAsFixed(
                                                                0)),
                                                            const Text(" x "),
                                                            Text(itemList[index]
                                                                .costPerUnit
                                                                .toStringAsFixed(
                                                                1)),
                                                            const Text(" = "),
                                                            Text(itemList[index]
                                                                .totalAmount
                                                                .toStringAsFixed(
                                                                1))
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "Tax : ",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .w600
                                                              ),
                                                            ),
                                                            Text(
                                                                itemList[index].tax == 0.0 || itemList[index].tax == null
                                                                    ? "  - "
                                                                    : itemList[index]
                                                                    .tax.toStringAsFixed(1)
                                                            ),
                                                            const Text(" % ")
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              "Discount : ",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .w600
                                                              ),
                                                            ),
                                                            Text(
                                                                itemList[index].discount == 0.0 ||
                                                                    itemList[index].discount == null
                                                                    ? "  - "
                                                                    : itemList[index]
                                                                    .discount!.toStringAsFixed(1)
                                                            ),
                                                            const Text(" % ")
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (_) {
                                                        return widget.invoiceModel != null
                                                        ? EditPage(
                                                          itemModel: itemList[index],
                                                          index: index,
                                                          state: state,
                                                          model: widget.invoiceModel!,
                                                        )
                                                        : EditPage(
                                                            itemModel: itemList[index],
                                                            index: index,
                                                            state: state,
                                                        );
                                                      }
                                                  )
                                              );
                                            },
                                          );
                                        }
                                      },
                                      itemCount: itemList.length,
                                      separatorBuilder: (context, index) =>
                                      const Divider(
                                        color: Colors.black, thickness: 1.0,),
                                    ),
                                  ),

                                  BlocBuilder<NetDetailCubit,
                                      NetTaxDiscountState>(
                                    builder: (context, state) {
                                      return buildOutput(
                                          value: (state is AddedTaxDiscount)
                                              ? state.tax == null
                                              ? " - "
                                              : "${state.tax.toString()} %"
                                              : " - ",
                                          tabName: "Net tax",
                                          onTap: () {
                                            showCustomDialog(
                                                initialValue: (state is AddedTaxDiscount) ? state.tax: null,
                                                context: context,
                                                controller: netTaxController,
                                                hintText: "Enter Net tax in %",
                                                labelText: "Net tax (%)",
                                                onPressed: () {
                                                  if (_formKey.currentState!.validate()) {
                                                    BlocProvider.of<NetDetailCubit>(context).addTax(double.parse(netTaxController.text), state);

                                                    if(widget.invoiceModel != null){
                                                      BlocProvider.of<HiveCubit>(context).updateInvoiceModel(
                                                        model: widget.invoiceModel!,
                                                        netTax: double.parse(netTaxController.text)
                                                      );
                                                    }

                                                    Navigator.pop(context);
                                                  }
                                                }
                                            );
                                          }
                                      );
                                    },
                                  ),
                                  BlocBuilder<NetDetailCubit,
                                      NetTaxDiscountState>(
                                      builder: (context, state) {
                                        return buildOutput(
                                            value: (state is AddedTaxDiscount)
                                                ? state.discount == null
                                                ? " - "
                                                : "${state.discount.toString()} %"
                                                : " - ",
                                            tabName: "Net discount",
                                            onTap: () {
                                              showCustomDialog(
                                                  initialValue: (state is AddedTaxDiscount) ? state.discount: null,
                                                  context: context,
                                                  hintText: "Enter Net discount in %",
                                                  labelText: "Net discount(%)",
                                                  controller: netDiscountController,
                                                  onPressed: () {
                                                    if (_formKey.currentState!.validate()) {
                                                      BlocProvider.of<NetDetailCubit>(context).addDiscount(
                                                          double.parse(netDiscountController.text),
                                                          state
                                                      );

                                                      if(widget.invoiceModel != null){
                                                        BlocProvider.of<HiveCubit>(context).updateInvoiceModel(
                                                            model: widget.invoiceModel!,
                                                            totalDiscount: double.parse(netDiscountController.text)
                                                        );
                                                      }

                                                      Navigator.pop(context);
                                                    }
                                                  }
                                              );
                                            }
                                        );
                                      }
                                  ),
                                  BlocBuilder<NetDetailCubit,
                                      NetTaxDiscountState>(
                                    builder: (context, state) {
                                      double discount = 0.0;
                                      double tax = 0.0;

                                      if (state is AddedTaxDiscount) {
                                        if (state.discount != null) {
                                          discount = state.discount!;
                                        }

                                        if (state.tax != null) {
                                          tax = state.tax!;
                                        }
                                      }
                                      return buildOutput(
                                          value: getTotal(itemList, discount, tax)
                                              .toStringAsFixed(2),
                                          tabName: "Total amount",
                                          onTap: null
                                      );
                                    },
                                  ),
                                  BlocBuilder<AdditionalCostCubit, AdditionalCostState>(
                                      builder: (context, state) {

                                        List<AdditionalCost> list = [];

                                        if(state is InitAdditionalCostState){
                                          list = state.additionalCost;
                                        }else if(state is AddedAdditionalCost){
                                          list = state.additionalCostList;
                                        }

                                        return buildOutput(
                                            value: getAdditionalCost(list).toStringAsFixed(1),
                                            tabName: "Additional cost",
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                              widget.invoiceModel != null
                                                  ? AdditionalCostPage(model: widget.invoiceModel,)
                                                  : AdditionalCostPage()
                                              ));
                                            }
                                        );
                                      }
                                  )
                                ],
                              );
                            }
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BlocBuilder<AdditionalInfoCubit, AdditionalInfoState>(
                            builder: (context, state){

                              ClientDetails? details;
                              if(state is AddedAdditionalInfo){
                                details = state.clientDetails;
                              }

                              return detailsTabBuilder(
                                  icon: Icons.supervised_user_circle,
                                  tabName: "Client details",
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => details == null
                                            ? ClientDetailsPage(model: widget.invoiceModel,)
                                            : ClientDetailsPage(details: details, model: widget.invoiceModel,)));
                                  }
                              );
                            },
                          ),
                          BlocBuilder<AdditionalInfoCubit, AdditionalInfoState>(
                            builder: (context, state){

                              DeliveryAddress? address;
                              if(state is AddedAdditionalInfo){
                                address = state.deliveryAddress;
                              }

                              return detailsTabBuilder(
                                  icon: Icons.home,
                                  tabName: "Delivery address",
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) =>
                                        address == null
                                            ? DeliveryAddressPage(model: widget.invoiceModel,)
                                            :DeliveryAddressPage(address: address, model: widget.invoiceModel)
                                    ));
                                  }
                              );
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BlocBuilder<AdditionalInfoCubit, AdditionalInfoState>(
                            builder: (context, state){

                              String? additionalNotes;
                              if(state is AddedAdditionalInfo){
                                additionalNotes = state.additionalNotes;
                              }
                              return detailsTabBuilder(
                                  icon: Icons.edit,
                                  tabName: "Additional notes",
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_){
                                              /*additionalNotes == null ? AdditionalNotesPage(

                                              ) :AdditionalNotesPage(
                                                model: widget.invoiceModel!,
                                                notes: additionalNotes,
                                              );*/
                                              if(widget.invoiceModel != null){
                                                return AdditionalNotesPage(
                                                  model: widget.invoiceModel!,
                                                  notes: additionalNotes,
                                                );
                                              }else if(additionalNotes == null){
                                                return AdditionalNotesPage();

                                              }else{
                                                return AdditionalNotesPage(notes: additionalNotes);
                                              }
                                            }
                                        )
                                    );
                                  }
                              );
                            },
                          ),
                          detailsTabBuilder(
                              icon: Icons.monetization_on,
                              tabName: "Additional costs",
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => widget.invoiceModel != null
                                        ? AdditionalCostPage(model: widget.invoiceModel,)
                                        : AdditionalCostPage())
                                );
                              }
                          )
                        ],
                      ),
                      BlocBuilder<AddItemCubit, AddItemState>(
                        builder: (context, itemState){
                          List<ItemModel> itemList = [];
                          if(itemState is InitItemState){
                            itemList = itemState.initItems;
                          }else if(itemState is ItemAddedState){
                            itemList = itemState.items;
                          }

                          return BlocBuilder<AdditionalInfoCubit, AdditionalInfoState>(
                            builder: (context, infoState){

                              ClientDetails? clientDetails;
                              DeliveryAddress? address;
                              String? notes;
                              bool paid = false;

                              if(infoState is InitAdditionalInfo){

                              }else if(infoState is AddedAdditionalInfo){
                                clientDetails = infoState.clientDetails;
                                address = infoState.deliveryAddress;
                                notes = infoState.additionalNotes;
                                paid = infoState.paid;
                              }

                              return BlocBuilder<AdditionalCostCubit, AdditionalCostState>(
                                builder: (context, costState){

                                  List<AdditionalCost> costList = [];
                                  if(costState is InitAdditionalCostState){
                                    costList = costState.additionalCost;
                                  }else if(costState is AddedAdditionalCost){
                                    costList = costState.additionalCostList;
                                  }
                                  return BlocBuilder<NetDetailCubit,NetTaxDiscountState>(
                                    builder: (context, taxDiscountState){

                                      double? tax;
                                      double? discount;

                                      if(taxDiscountState is AddedTaxDiscount){

                                        tax = taxDiscountState.tax;
                                        discount = taxDiscountState.discount;

                                      }

                                      return widget.invoiceModel == null ? ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(
                                                Colors.purple),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30.0),
                                                )
                                            )
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                             widget.invoiceModel == null ? "Create" : "Update",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                                letterSpacing: 5.0
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          if(itemList.isNotEmpty && widget.invoiceModel == null){
                                            BlocProvider.of<HiveCubit>(context).addData(
                                                InvoiceModel(
                                                    clientDetail: clientDetails,
                                                    deliveryAddress: address,
                                                    notes: notes,
                                                    date: DateTime.now(),
                                                    invoiceNumber: BlocProvider.of<HiveCubit>(context).getKey(),
                                                    items: itemList,
                                                    additionalCost: costList,
                                                    totalDiscount: discount,
                                                    tax: tax
                                                )
                                            );
                                            Navigator.pop(context);
                                            BlocProvider.of<AddItemCubit>(context).removeAll();
                                            BlocProvider.of<AdditionalInfoCubit>(context).removeAll();
                                            BlocProvider.of<AdditionalCostCubit>(context).removeAll();
                                            BlocProvider.of<NetDetailCubit>(context).removeAll();

                                          }else if(itemList.isNotEmpty && widget.invoiceModel != null){
                                            BlocProvider.of<HiveCubit>(context).updateInvoiceModel(
                                                model: InvoiceModel(
                                                    clientDetail: clientDetails,
                                                    deliveryAddress: address,
                                                    notes: notes,
                                                    date: widget.invoiceModel!.date,
                                                    invoiceNumber: widget.invoiceModel!.invoiceNumber,
                                                    items: itemList,
                                                    additionalCost: costList,
                                                    totalDiscount: discount,
                                                    tax: tax,
                                                    paid: paid
                                                )
                                            );
                                            Navigator.pop(context);
                                            BlocProvider.of<AddItemCubit>(context).removeAll();
                                            BlocProvider.of<AdditionalInfoCubit>(context).removeAll();
                                            BlocProvider.of<AdditionalCostCubit>(context).removeAll();
                                            BlocProvider.of<NetDetailCubit>(context).removeAll();
                                          }else{
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                behavior: SnackBarBehavior.floating,
                                                content: const Text(
                                                  "Add Items",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                  ),
                                                ),
                                                backgroundColor: Colors.purple,
                                                action: SnackBarAction(
                                                  label: "Add",
                                                  textColor: Colors.white,
                                                  onPressed: (){
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(builder: (_) => widget.invoiceModel != null
                                                            ? AddItemPage(state: state, hiveModel: widget.invoiceModel,)
                                                            : AddItemPage(state: state)
                                                        )
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      )
                                      : const SizedBox();
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ) ;
            },
          )
      ),
    );
  }

  Widget detailsTabBuilder({
    required IconData icon,
    required String tabName,
    required VoidCallback onTap
  }) {
    return Container(
      margin: EdgeInsets.all(10.0),
      height: 100.0,
      width: 120.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.purple, width: 3.0),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(15.0),
        child: InkWell(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 35.0,
                ),
                Text(
                  tabName,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          highlightColor: Colors.purple.withOpacity(0.2),
          onTap: onTap,
        ),
      ),
    );
  }

  String getKey(int lengthOfBox) {
    return "INV_0${lengthOfBox + 1}";
  }

  Future<bool> _onWillPop() {

    showDialog(
        context: context,
        builder: (mainContext) {
          return AlertDialog(
            content: const Text(
                "Do you want to exit ?"
            ),
            actions: [
              TextButton(
                  onPressed: () {

                    int popBack = 2;
                    Navigator.popUntil(context, (route) => popBack-- <= 0);

                    BlocProvider.of<HiveCubit>(context).refresh();
                    BlocProvider.of<AddItemCubit>(context).removeAll();
                    BlocProvider.of<AdditionalInfoCubit>(context).removeAll();
                    BlocProvider.of<AdditionalCostCubit>(context).removeAll();
                    BlocProvider.of<NetDetailCubit>(context).removeAll();

                  },
                  child: const Text("Yes")
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")
              ),
            ],
          );
        }
    );

    return Future.value(true);
  }

  double getTotal(List<ItemModel> list, double discount, double tax) {
    double totalCost = 0.0;
    double discountCost = 0.0;
    double taxCost = 0.0;
    double finalCost = 0.0;

    list.map((item) => totalCost = totalCost + item.totalAmount).toList();

    discountCost = totalCost * (discount / 100);

    taxCost = totalCost * (tax / 100);

    finalCost = totalCost + taxCost - discountCost;

    return finalCost;
  }

  buildOutput({
    required String value,
    required String tabName,
    required VoidCallback? onTap
  }) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.5),
        padding: EdgeInsets.only(right: 5.0),
        height: 25.0,
        width: double.infinity,
        color: Colors.purple,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "$tabName : ",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),

          ],
          crossAxisAlignment: CrossAxisAlignment.center,

        ),
      ),
      highlightColor: Colors.black.withOpacity(0.2),
      onTap: onTap,
    );
  }

  showCustomDialog({
    required BuildContext context,
    required String hintText,
    required String labelText,
    required VoidCallback onPressed,
    required TextEditingController controller,
    double? initialValue
  }) {

    controller.text = initialValue?.toString() ?? "";

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: TextFormField(
                validator: (val) => val!.isEmpty ? "required field" : null,
                keyboardType: TextInputType.number,
                controller: controller,
                decoration: InputDecoration(
                  errorStyle: const TextStyle(
                      color: Colors.black
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: Colors.black, width: 2.0)
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: Colors.black, width: 2.0)
                  ),
                  hintText: hintText,
                  hintStyle: TextStyle(
                      color: Colors.purple[400]
                  ),
                  label: Text(
                      labelText, style: const TextStyle(color: Colors.purple)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: Colors.purple, width: 2.0)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: Colors.purple, width: 2.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                          color: Colors.purple, width: 2.0)
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: onPressed,
                child: const Text(
                  "OK",
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.black
                    ),
                  )
              ),
            ],
          );
        }
    );
  }
  
  double getAdditionalCost(List<AdditionalCost> list){
    
    double totalAdditionalCost = 0.0;
    
    list.map((cost) => totalAdditionalCost += cost.cost).toList();
    
    return totalAdditionalCost;
  }

  Widget switcherWidget({
    required bool state,
    required AdditionalInfoState cubitState
  }){

    return FlutterSwitch(
        value: state,
        height: 30.0,
        width: 80.0,
        onToggle: (val){
          if(cubitState is AddedAdditionalInfo) {
            if(cubitState.paid != val) BlocProvider.of<AdditionalInfoCubit>(context).addPaymentStatus(widget.invoiceModel!, val);
          }
          BlocProvider.of<HiveCubit>(context).updateInvoiceModel(model: widget.invoiceModel!, paid: val);
        },
        activeText: "Paid",
        inactiveText: "Unpaid",
        activeTextColor: Colors.purple,
        inactiveTextColor: Colors.black,
        activeColor: Colors.white,
        inactiveColor: Colors.white,
        toggleBorder: Border.all(
          color: Colors.black,
          width: 2.5
        ),
        valueFontSize: 12.0,
        showOnOff: true,
        borderRadius: 8.0,
    );
  }

  showNotification(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Add some basic data to generate PDF"),
        backgroundColor: Colors.purple,
        action: SnackBarAction(
          label: "Add",
          textColor: Colors.white,
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => BasicInfo(box: Hive.box<BasicInfoModel>('basicInfo'))));
          },
        ),
      )
    );

  }

  @override
  void dispose() {

    super.dispose();
  }

}

