
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/ItemsProvieder.dart';
import 'package:simple_app/bloc_items/bolc_items_bloc.dart';
import 'package:simple_app/cart_list.dart';
import 'package:simple_app/repository/Items_repository.dart';
import 'package:simple_app/wellcom.dart';
import 'bloc_category/items_bloc.dart';
import 'login_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartList()),
        ChangeNotifierProvider(create: (_) => ItmesProvider()),
      ],
      child: Application(),
    ),
  );
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor:Color.fromRGBO(232, 87,102,1),
        focusColor:Color.fromRGBO(232, 87,102,1),
        appBarTheme: AppBarTheme(

          color: Color.fromRGBO(232, 87,102,1),
          centerTitle: true,
        )
      ),
      home: MultiBlocProvider(
        child:Wellcom(),
        providers: [
          BlocProvider(
            create: (BuildContext context) => ItemsBloc(ItemRepositoryIMP())..add(FetchCategory()),
          ),
          BlocProvider(
            create: (BuildContext context) => BolcItemsBloc(ItemRepositoryIMP())..add(FetchItems(1)),
          ),
          BlocProvider(
            create: (BuildContext context) => BolcItemsBloc(ItemRepositoryIMP())..add(FetchAllItems()),
          ),
        ],
      )
    );
  }
}


