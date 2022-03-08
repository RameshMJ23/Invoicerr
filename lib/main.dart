import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoicerr/bloc/Net_detail_bloc/net_detail_cubit.dart';
import 'package:invoicerr/bloc/add_items_bloc/add_item_cubit.dart';
import 'package:invoicerr/bloc/additional_costs_bloc/addtional_cost_cubit.dart';
import 'package:invoicerr/bloc/additional_info_bloc/additional_info_cubit.dart';
import 'package:invoicerr/bloc/hive_bloc/hive_cubit.dart';
import 'package:invoicerr/generated/additional_cost_generated.dart';
import 'package:invoicerr/generated/basic_info_generated.dart';
import 'package:invoicerr/generated/client_details_generated.dart';
import 'package:invoicerr/generated/delivery_address_generated.dart';
import 'package:invoicerr/generated/invoice_model_generator.dart';
import 'package:invoicerr/generated/item_model_generated.dart';
import 'package:invoicerr/model/basic_info.dart';
import 'package:invoicerr/model/invoice_model.dart';
import 'package:invoicerr/screens/basic_info_screen.dart';
import 'package:invoicerr/screens/main_page.dart';


void main() async{

  await Hive.initFlutter();
  Hive.registerAdapter(BasicInfoModelAdapter());
  Hive.registerAdapter(InvoiceModelAdapter());
  Hive.registerAdapter(ItemModelAdapter());
  Hive.registerAdapter(AdditionalCostAdapter());
  Hive.registerAdapter(ClientDetailsAdapter());
  Hive.registerAdapter(DeliveryAddressAdapter());
  await Hive.openBox<InvoiceModel>('invoicebox');
  await Hive.openBox<BasicInfoModel>('basicInfo');
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AddItemCubit()),
        BlocProvider(create: (_) => NetDetailCubit()),
        BlocProvider(create: (_) => AdditionalCostCubit()),
        BlocProvider(create: (_) => AdditionalInfoCubit()),
        BlocProvider(create: (_) => HiveCubit(), lazy: false,)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Invoicerr',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainPage()
      ),
    );
  }

}
