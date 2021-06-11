import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/repository/Items_repository.dart';

import 'bloc_category/items_bloc.dart';
import 'bloc_items/bolc_items_bloc.dart';
import 'home/home.dart';
import 'login_view.dart';


class Wellcom extends StatefulWidget {
  @override
  _WellcomState createState() => _WellcomState();
}

class _WellcomState extends State<Wellcom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,elevation: 0,),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset("image/speedoo.jpg",height: 120,width:120,),
        ),
      ),

    );
  }

  @override
  void initState() {
     _isLogin();
  }
  void PassHome(){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MultiBlocProvider(
          child:Home(),
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
        )));
  }

  void PassLogin(){
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MultiBlocProvider(
          child:LoginView(),
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
        )));
  }
  Future<void> _isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getString("token")!=""){
      PassHome();
    }else{
       PassLogin();
    }
  }
}
