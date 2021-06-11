import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/bloc_category/items_bloc.dart';
import 'package:simple_app/bloc_items/bolc_items_bloc.dart';
import 'package:simple_app/home/home.dart';
import 'package:http/http.dart' as http;
import 'package:simple_app/repository/Items_repository.dart';
import 'package:simple_app/setting/seetting.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  BolcItemsBloc _bolcItemsBloc;
  ItemsBloc _itemsBloc;
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  String _IP="";
  String _PORT="";
  FToast fToast=FToast();
  bool isLogin;
  @override
  Widget build(BuildContext context) {
    _bolcItemsBloc=BlocProvider.of<BolcItemsBloc>(context);
    _itemsBloc=BlocProvider.of<ItemsBloc>(context);
    return Scaffold(
        appBar: AppBar(
          elevation:0,
          leading:IconButton(
            icon: Icon(Icons.settings,color: Colors.white,),
            onPressed: () async {
              String received = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Setting()));
              if(received=="backSetting"){
                setState(() {
                  getSetting();
                  received="";
                });
              }
            },
          ),
        ),
        body:Column(
          children: [
            Expanded(child:Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        "مرحبا..... قم بتسجيل الدخول",
                        style:GoogleFonts.tajawal(
                            textStyle: TextStyle(color: Colors.redAccent,fontSize: 23)
                        ),
                      )),
                  CircleAvatar(
                    radius: 90,
                    backgroundColor: Color.fromRGBO(245, 1,9,1),
                    child: Image.asset("image/speedoo.jpg",width: 120,height: 120,),
                  )
                ],
              ),

            ),
            ),
            Expanded(child:Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _username,
                      decoration: InputDecoration(
                        filled:true,
                        hintText: "اسم المستخدم",
                        prefixIcon: Icon(Icons.person),
                        hintStyle:GoogleFonts.tajawal(),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(
                                color:Color.fromRGBO(232, 87,102,1),
                                width: 1.5
                            )
                        ),
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.5
                            )
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _password,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        prefixStyle: TextStyle(color: Colors.redAccent),
                        filled:true,
                        hintText: "كلمه المرور",
                        hintStyle:GoogleFonts.tajawal(),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(
                                color:Color.fromRGBO(232, 87,102,1),
                                width: 1.5
                            )
                        ),
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(20.0),
                            ),
                            borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.5
                            )
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                        borderRadius:  BorderRadius.circular(30.0),
                      ),
                      minWidth: double.infinity,
                      height: 60.0,
                      child: RaisedButton(
                          color: Color.fromRGBO(232, 87,102,1),
                          onPressed:(){
                            LoginEvent();
                          },
                          child:Text("تسجيل دخول",style:GoogleFonts.tajawal(
                              textStyle: TextStyle(color: Colors.white)
                          ),)
                      ),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      );

  }

  @override
  void initState() {
    getSetting();
  }

  void LoginEvent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data = {'username':_username.text,'password':_password.text};
    String body = json.encode(data);
    http.Response response = await http.post(
      Uri.http("${prefs.getString("ip")}:${prefs.getString("port")}",'/iraqsoft/speedoo/api/v1/auth'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if(response.statusCode==200){
      prefs.setString("token", response.body);
      PassHome();
    }else{
      fToast.context=context;
      fToast.showToast(
        child: _toast(),
        gravity: ToastGravity.TOP,
        toastDuration: Duration(seconds: 3),
      );
    }
  }

  Future<void> getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _IP = prefs.getString("ip");
    _PORT=prefs.getString("port");
  }

  Widget _toast(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color.fromRGBO(232, 87,102,1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error,color: Colors.white,),
          SizedBox(
            width: 4.0,
          ),
          Text("لم يتم تسجيل الدخول ",style: TextStyle(color: Colors.white,fontSize: 14)),
        ],
      ),
    );
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
        )
        ));
  }

}
