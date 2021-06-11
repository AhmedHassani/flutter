import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String _IP="ip";
  String _PORT="port";
  String valueChose;
  FToast fToast=FToast();
  var listtype= {"وكيل","جمله","مفرد"};
  TextEditingController _ipConrtoller = TextEditingController();
  TextEditingController _portController = TextEditingController();
  TextEditingController _DiviceIdController = TextEditingController();
  String _valuetype="";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Setting",style:TextStyle(color: Colors.white),),
          backgroundColor: Color.fromRGBO(232, 87,102,1),
          leading:Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                 Navigator.pop(context,"backSetting");
              },
            ),
          ),
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller:_ipConrtoller,
                decoration: InputDecoration(
                    labelText:"IP",
                    hintText: "IP",
                    focusColor:Color.fromRGBO(232, 87,102,1),
                    border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _portController,
                decoration: InputDecoration(
                    labelText:"PORT" ,
                    hintText: "PORT",
                    focusColor: Color.fromRGBO(232, 87,102,1),
                    border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _DiviceIdController,
                decoration: InputDecoration(
                    labelText:"Device ID",
                    hintText: "device id",
                    focusColor: Color.fromRGBO(232, 87,102,1),
                    border: OutlineInputBorder(

                    )
                ),
              ),
            ),
            Container(
               height: 60,
               margin: EdgeInsets.all(12),
               decoration: BoxDecoration(
                   border: Border.all(
                     color: Colors.grey,
                     width: 1,
                   )),
               child:  Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: DropdownButton(
                   hint: Text("$_valuetype",style:TextStyle(fontWeight: FontWeight.bold),),
                   style: TextStyle(wordSpacing: 2,color: Colors.black),
                   underline: SizedBox(),
                   isExpanded: true,
                    value: valueChose,
                   onChanged: (newValue){
                     setState(() {
                       valueChose=newValue;
                     });
                   },
                   items: listtype.map((item)  {
                     return DropdownMenuItem(
                         value: item,
                         child:Text("${item  == null ? "نوع العمله" : item}")
                     );
                   }).toList(),
                 ),
               ),
             ),
            FlatButton(
              color: Color.fromRGBO(232, 87,102,1),
              textColor: Colors.white,
              child: Text("حفظ",style: TextStyle(color: Colors.white),),
              onPressed: (){
                saveSetting(_ipConrtoller.text,_portController.text,valueChose,_DiviceIdController.text);
              },
            )
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    getSetting();
  }

  Future<void> saveSetting(String ip,String port,type,String did) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_IP, ip);
    prefs.setString(_PORT, port);
    prefs.setString("DID", did);
    if(type==null){
      type=_valuetype;
    }
    prefs.setString("type",type);
    prefs.commit();
    fToast.context=context;
    fToast.showToast(
      child: _toast(),
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 2),
    );
  }

  //get string

  Future<Void> getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _ipConrtoller.text=prefs.getString(_IP);
    _portController.text=prefs.getString(_PORT);
    _DiviceIdController.text=prefs.getString("DID");
     print(prefs.getString("type"));
     setState(() {
       _valuetype=prefs.getString("type");
     });

  }
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
        Icon(Icons.check,color: Colors.white,),
        SizedBox(
          width: 4.0,
        ),
        Text("تم حفظ الاعدادات",style: TextStyle(color: Colors.white,fontSize: 14)),
      ],
    ),
  );
}




