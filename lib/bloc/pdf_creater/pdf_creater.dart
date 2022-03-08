import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoicerr/model/additional_cost_model.dart';
import 'package:invoicerr/model/basic_info.dart';
import 'package:invoicerr/model/invoice_model.dart';
import 'package:invoicerr/model/item_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PdfCreator{

  static pw.Row customRowTitle({
    required String itemNumber,
    required String itemName,
    required String costPerUnit,
    required String tax,
    required String totalAmount,
    required String discount,
    required  String numberOfItems,
    String? notes
  }){
    return pw.Row(
      children: [
        pw.Text(itemNumber),
        pw.SizedBox(width: 10.0),
        pw.Text(itemName),
        pw.SizedBox(width: 10.0),
        pw.Text(costPerUnit),
        pw.SizedBox(width: 10.0),
        pw.Text(tax),
        pw.SizedBox(width: 10.0),
        pw.Text(totalAmount),
        pw.SizedBox(width: 10.0),
        pw.Text(discount),
        pw.SizedBox(width: 10.0),
        pw.Text(numberOfItems),
      ]
    );
  }

  static pw.Widget tileWidget({
    required String titleName,
  }){
    return pw.Container(
      child: pw.Text(titleName, style: pw.TextStyle(color: PdfColor.fromHex("#fff5fe"), fontWeight: pw.FontWeight.bold)),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(5.0),
        color: PdfColor.fromHex("#a60095"),
      ),

      padding: pw.EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),

    );
  }

  static Future<Uint8List> createInvoice(String invoiceName, InvoiceModel invoiceModel){

    BasicInfoModel basicInfo = Hive.box<BasicInfoModel>('basicInfo').get('userInfo')!;
    /*Hive.boxExists('basicInfo').then((value) {
      if(value && Hive.box('basicInfo').containsKey('userInfo')){
        basicInfo = ;
      }
    });*/
    List<ItemModel> itemList = invoiceModel.items;

    List<pw.Row> list = [];
    List<pw.Widget> itemNumberList = [tileWidget(titleName: "Item no.")];
    List<pw.Widget> itemNameList = [tileWidget(titleName: "Item name")];
    List<pw.Widget> costPerUnitList = [tileWidget(titleName: "cost")];
    List<pw.Widget> taxList = [tileWidget(titleName: "tax")];
    List<pw.Widget> totalAmountList = [tileWidget(titleName: "Total amount")];
    List<pw.Widget> discountList = [tileWidget(titleName: "discount")];
    List<pw.Widget> numberOfItemsList = [tileWidget(titleName: "No. of Items")];
    List<pw.Widget> additionalCharges = [pw.Text("Additional Charges : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),];
    DateFormat dateFormat = DateFormat.yMd();

    String date = dateFormat.format(invoiceModel.date);

    itemList.map((item){
      itemNumberList.add(pw.Padding(padding: const pw.EdgeInsets.only(top: 7.5), child: pw.Text((itemList.indexOf(item) + 1).toString())));
      itemNameList.add(pw.Padding(padding: const pw.EdgeInsets.only(top: 7.5), child: pw.Text(item.itemName)));
      costPerUnitList.add(pw.Padding(padding: const pw.EdgeInsets.only(top: 7.5), child: pw.Text(item.costPerUnit.toStringAsFixed(1))));
      taxList.add( pw.Padding(padding: const pw.EdgeInsets.only(top: 7.5), child: pw.Text(item.tax != null ? "${item.tax.toStringAsFixed(1)} %" : " - ")));
      totalAmountList.add(pw.Padding(padding: const pw.EdgeInsets.only(top: 7.5), child: pw.Text(item.totalAmount.toStringAsFixed(2))));
      discountList.add(pw.Padding(padding: const pw.EdgeInsets.only(top: 7.5), child: pw.Text(item.discount != null ? "${item.discount!.toStringAsFixed(1)} %"  : " - ")));
      numberOfItemsList.add(pw.Padding(padding: const pw.EdgeInsets.only(top: 7.5), child: pw.Text(item.numberOfItems.toStringAsFixed(1))));
    }).toList();

    if(invoiceModel.additionalCost.isNotEmpty){
      invoiceModel.additionalCost.map((cost){
        additionalCharges.add(
            pw.Padding(
                padding: pw.EdgeInsets.symmetric(vertical: 5.0),
                child: pw.Text("${invoiceModel.additionalCost.indexOf(cost) + 1}) ${cost.costName} : ${cost.cost.toStringAsFixed(1)}")
            )
        );
      }).toList();
    }else{
      additionalCharges.add(
          pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: 5.0),
              child: pw.Text("nil")
          )
      );
    }


    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context){
          return pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: pw.Column(
                children:[
                  pw.Text(
                    invoiceName,
                    style: pw.TextStyle(
                      fontSize: 22.0,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 2.5
                    )
                  ),
                  pw.SizedBox(
                      height: 10.0
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      basicInfo != null
                      ? pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(basicInfo.companyName),
                            pw.Text(basicInfo.addressL1),
                            pw.Text(basicInfo.addressL2),
                            pw.Text(basicInfo.addressL3),
                            pw.Row(
                              children: [
                                pw.Text("Name : "),
                                pw.Text(basicInfo.name)
                              ]
                            ),
                            pw.Row(
                                children: [
                                  pw.Text("Contanct no. : "),
                                  pw.Text(basicInfo.contactNo)
                                ]
                            ),
                            pw.Row(
                                children: [
                                  pw.Text("email : "),
                                  pw.Text(basicInfo.email)
                                ]
                            )

                          ]
                      ): pw.SizedBox(),
                      invoiceModel.clientDetail != null
                        ? pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("Invoice number : ${invoiceModel.invoiceNumber}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                            pw.Text("Date : $date", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                            pw.SizedBox(height: 15.0),
                            pw.Text("Client Details : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                            pw.Text(invoiceModel.clientDetail!.clientName),
                            pw.Text(invoiceModel.clientDetail!.companyName),
                            pw.Text(invoiceModel.clientDetail!.companyAddress1),
                            pw.Text(invoiceModel.clientDetail!.companyAddress2),
                            pw.Text(invoiceModel.clientDetail!.companyAddress3),
                          ]
                      )
                      : pw.SizedBox()
                    ]
                  ),
                  pw.Divider(),
                  pw.SizedBox(
                    height: 10.0
                  ),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children:[
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: itemNumberList
                      ),
                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: itemNameList
                      ),
                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: costPerUnitList
                      ),
                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: numberOfItemsList
                      ),
                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: discountList
                      ),
                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: taxList
                      ),
                      pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: totalAmountList
                      ),
                    ]
                  ),
                  pw.SizedBox(
                    height: 20.0
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: additionalCharges
                          ),
                          additionalCharges.length > 2
                            ? pw.Padding(padding: pw.EdgeInsets.only(top: 10.0),
                              child: pw.Text(
                                "Total : ${getTotalAdditionalCost(invoiceModel.additionalCost).toStringAsFixed(1)}",
                                style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold
                                )
                              ))
                            : pw.SizedBox()
                        ]
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          additionalInfoWidget(
                              "Net Discount : ",
                              invoiceModel.totalDiscount != null
                                  ? "${invoiceModel.totalDiscount!.toStringAsFixed(1)} % "
                                  : " - % "
                          ),
                          pw.SizedBox(
                              height: 6.0
                          ),
                          additionalInfoWidget(
                              "Net Tax : ",
                              invoiceModel.tax != null
                                  ? "${invoiceModel.tax!.toStringAsFixed(1)} % "
                                  : " - % "
                          ),
                          pw.SizedBox(
                              height: 6.0
                          ),
                          additionalInfoWidget(
                              "Total Amount (items) : ",
                              getTotal(
                                  itemList,
                                  invoiceModel.totalDiscount != null ? invoiceModel.totalDiscount! : 0.0,
                                  invoiceModel.tax != null ? invoiceModel.tax! : 0.0
                              ).toStringAsFixed(2)
                          ),
                          pw.SizedBox(
                              height: 20.0
                          ),
                          additionalInfoWidget(
                              "Payment amount : ",
                              getTotalPayment(
                                  getTotal(
                                      itemList,
                                      invoiceModel.totalDiscount != null ? invoiceModel.totalDiscount! : 0.0,
                                      invoiceModel.tax != null ? invoiceModel.tax! : 0.0
                                  ),
                                  invoiceModel.additionalCost
                              ).toStringAsFixed(2),
                            fontSize: 15
                          )
                        ]
                      )
                    ]
                  ),
                  pw.Spacer(

                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.symmetric(vertical: 15.0),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                              children: [
                                invoiceModel.notes != null
                                  ? pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text("Additional notes : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                                    pw.Text(invoiceModel.notes ?? ""),
                                  ]
                                ) : pw.SizedBox()
                              ]
                          ),
                          pw.Column(
                              children: [
                                invoiceModel.deliveryAddress != null
                                    ? pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text("Delivery Details : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                                      pw.Text("Name : ${invoiceModel.deliveryAddress!.receiverName} "),
                                      pw.Text("Contact no. : ${invoiceModel.deliveryAddress!.receiverNum}"),
                                      pw.Row(
                                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                                        children: [
                                          pw.Text("Address :"),
                                          pw.Column(
                                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Text(
                                                  invoiceModel.deliveryAddress!.receiverAddress1
                                              ),
                                              pw.Text(
                                                  invoiceModel.deliveryAddress!.receiverAddress2
                                              ),
                                              pw.Text(
                                                  invoiceModel.deliveryAddress!.receiverAddress3
                                              )
                                            ]
                                          )
                                        ]
                                      )
                                    ]
                                ) : pw.SizedBox()
                              ]
                          )
                        ]
                    )
                  )
                ]
            )
          );
        }
      )
    );

    return pdf.save();
  }

  static double getTotal(List<ItemModel> list, double discount, double tax) {
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

  static double getTotalPayment(double totalItemCost, List<AdditionalCost> addCostList){

    double additionalCost = 0.0;

    addCostList.map((cost) => additionalCost += cost.cost).toList();

    return totalItemCost + additionalCost;
  }

  static double getTotalAdditionalCost(List<AdditionalCost> costList){

    double totalCost = 0.0;
    costList.map((cost) => totalCost += cost.cost).toList();

    return totalCost;
  }


  static pw.Widget additionalInfoWidget(
      String infoName,
      String infoValue,
      {double fontSize = 12}
  ){
      return pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Container(
              padding: pw.EdgeInsets.only(top: 7.0, left: 35.0, right: 35.0, bottom: 7.0),

              decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex("#a60095"),
                  borderRadius: pw.BorderRadius.circular(10.0)
              ),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Text(
                        infoName,
                        style: pw.TextStyle(
                            color: PdfColor.fromHex("#fff5fe"),
                            fontWeight: pw.FontWeight.bold,
                            fontSize: fontSize
                        )
                    ),
                    pw.Text(
                        infoValue,
                        style: pw.TextStyle(
                            color: PdfColor.fromHex("#fff5fe"),
                            fontWeight: pw.FontWeight.bold,
                            fontSize: fontSize
                        )
                    )
                  ]
              )
          )
      );
  }

  static savePdf(String fileName, Uint8List pdf) async{

    final path = await getApplicationDocumentsDirectory();

    String filePath = "${path.path}/$fileName.pdf";

    File file = File(filePath);

    file.writeAsBytes(pdf);

    OpenFile.open(filePath);
  }

}