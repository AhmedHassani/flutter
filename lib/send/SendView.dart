import 'dart:ffi';

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/models/items.dart';
import 'package:simple_app/models/vacount.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';



import '../cart_list.dart';
import 'TicketImp.dart';

class SentView extends StatefulWidget {

  VAcount _item=VAcount();
  SentView(this._item);

  @override
  _SentViewState createState() => _SentViewState();
}

class _SentViewState extends State<SentView> {
  String typePrice="";
  String T_SALES="";
  String T_SALES_DETILES="";
  String DeviceId="";
  TextEditingController _custemorConrtoller =TextEditingController();
  TextEditingController _totalConrtoller =TextEditingController();
  TextEditingController _discountConrtoller =TextEditingController();
  TextEditingController _priceConrtoller =TextEditingController();
  TextEditingController _pricePayConrtoller =TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addreesController = TextEditingController();
  CartList _cartList =CartList();
  bool _isDept  =false;
  //printer info
  bool connected = false;
  List availableBluetoothDevices = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(232, 87,102,1),
        title: Text("الفاتوره",style:GoogleFonts.tajawal(),),
        centerTitle: true,
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.add,color: Color.fromRGBO(232, 87,102,1),),
                  onPressed: (){
                    _displayTextInputDialog(context);
                 }),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    textAlign:TextAlign.right,
                    controller:_custemorConrtoller,
                    decoration: InputDecoration(
                      labelText:"العميل",
                      hintText: "",
                      hintStyle: GoogleFonts.tajawal(),
                      focusColor: Colors.lightGreen,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              textAlign:TextAlign.right,
              controller:_totalConrtoller,
              decoration: InputDecoration(
                labelText:"المبلغ الكلي",
                hintText: "",
                hintStyle: font(),
                focusColor: Color.fromRGBO(232, 87,102,1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              textAlign:TextAlign.right,
              controller:_discountConrtoller,
              keyboardType: TextInputType.number,
              onChanged: (value){
                 if(!(value=="")){
                   setState(() {
                     _priceConrtoller.text="${_setMoneyFormatt(_cartList.sum-double.parse(_discountConrtoller.text))}";
                   });
                 }
              },
              decoration: InputDecoration(
                labelText:"الخصم",
                hintText: "",
                hintStyle: font(),
                focusColor: Color.fromRGBO(232, 87,102,1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign:TextAlign.right,
              controller:_priceConrtoller,
              decoration: InputDecoration(
                labelText:"المبلغ الصافي",
                hintText: "",
                hintStyle: font(),
                focusColor: Color.fromRGBO(232, 87,102,1),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text("نقد",style:font(),),
              ),
              Checkbox(
                checkColor: Colors.white,
                focusColor: Color.fromRGBO(232, 87,102,1),
                activeColor: Color.fromRGBO(232, 87,102,1),
                value: this._isDept,
                onChanged: (bool value) {
                  setState(() {
                    this._isDept = value;
                    _pricePayConrtoller.text=_setMoneyFormatt(double.parse(_priceConrtoller.text.replaceAll(",", "")));
                  });
                },
              ),
              Flexible(
                child:Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    textAlign:TextAlign.right,
                    keyboardType: TextInputType.number,
                    controller:_pricePayConrtoller,
                    decoration: InputDecoration(
                      labelText:"المبلغ المسدد",
                      hintText: "",
                      hintStyle: font(),
                      focusColor: Color.fromRGBO(232, 87,102,1),
                    ),
                  ),
                ),
              ),
            ],
          ),
         Row(
           children: [
             Align(
               alignment: Alignment.centerRight,
               child: Padding(
                 padding: const EdgeInsets.all(12.0),
                 child: FlatButton(
                     color: Color.fromRGBO(232, 87,102,1),
                     onPressed: (){
                       _printValue();
                     },
                     child: Text("Copy T_SALES",style:GoogleFonts.tajawal(textStyle:TextStyle(color: Colors.white)),)
                 ),
               ),
             ),
             Align(
               alignment: Alignment.centerRight,
               child: Padding(
                 padding: const EdgeInsets.all(12.0),
                 child: FlatButton(
                     color: Color.fromRGBO(232, 87,102,1),
                     onPressed: (){
                       _printValue2();
                     },
                     child: Text("Copy T_SALES_DETILES",style:GoogleFonts.tajawal(textStyle:TextStyle(color: Colors.white)),)
                 ),
               ),
             )
           ],
         )
        ],
      )
    );
  }


  @override
  void initState() {
    _cartList=Provider.of<CartList>(context, listen: false);
    _custemorConrtoller.text=widget._item.accountNAME;
    _totalConrtoller.text="${_setMoneyFormatt(_cartList.sum)}";
    setState(() {
      getSetting();
    });
  }

  _setMoneyFormatt(double price){
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: price);
    return fmf.output.nonSymbol.replaceAll(RegExp(r'.00*$'), "");
  }

  Future<Void> getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    typePrice=prefs.getString("type");
    DeviceId=prefs.getString("DID");
  }


  double setPrice(Items items, typePrice) {
    if(typePrice=="وكيل"){
      return items.priceSALE3;
    }else if(typePrice=="جمله"){
      return items.priceSALE2;
    }else if(typePrice=="مفرد"){
      return items.priceSALE1;
    }else{
      return items.priceSALE1;
    }
  }

  _printValue(){
    getSetting();
    T_SALES="";
    T_SALES_DETILES="";
    T_SALES="[${widget._item.id}];[${widget._item.accountNAME}];[${_phoneController.text}];"
        "[${_addreesController.text}];[${_discountConrtoller}];[${widget._item.mandoobCODE}];[${DeviceId}]";

     for(CartValues cartValues in _cartList.items){
       T_SALES_DETILES=T_SALES_DETILES+"[${cartValues.items.itemCODE}];[${cartValues.items.unitNAME}]"
           "[${cartValues.items.unitQTY}];[${cartValues.items.unitQTY}];[${cartValues.items.storeCODE}];"
           "[${cartValues.items.priceCOST}];[${setPrice(cartValues.items,typePrice)}]";
     }
     FlutterClipboard.copy(T_SALES);
     printPOS();
  }
  _printValue2(){
    getSetting();
    T_SALES_DETILES="";
    for(CartValues cartValues in _cartList.items){
      T_SALES_DETILES=T_SALES_DETILES+"[${cartValues.items.itemCODE}];[${cartValues.items.unitNAME}]"
          "[${cartValues.items.unitQTY}];[${cartValues.items.unitQTY}];[${cartValues.items.storeCODE}];"
          "[${cartValues.items.priceCOST}];[${setPrice(cartValues.items,typePrice)}]";
    }
    FlutterClipboard.copy(T_SALES_DETILES);
    printPOS();
    setConnect("00:15:83:45:F2:13");
    printTicket();
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,

        builder: (context) {
          return AlertDialog(
            title: Text(
              'معلومات العميل',
              style:GoogleFonts.tajawal(),
            ),
            content: Container(
              height: 145,
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                    },
                    controller: _phoneController,
                    keyboardType:TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "رقم الهاتف",
                        hintStyle: GoogleFonts.tajawal()
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                    },
                    controller: _addreesController,
                    decoration: InputDecoration(
                        hintText: "العنوان",
                        hintStyle: GoogleFonts.tajawal()
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Align(
                  alignment: Alignment.bottomRight,
                  child:RaisedButton(
                    onPressed: (){
                      print(_phoneController.text);
                      print(_addreesController.text);
                      Navigator.pop(context);
                    },
                    color: Color.fromRGBO(232, 87,102,1),
                    child: Text(
                      'حفظ',
                      style:GoogleFonts.tajawal(textStyle:TextStyle(color: Colors.white)),
                    ),)
              ),

            ],
          );
        });
  }
  font(){
    return GoogleFonts.tajawal(
        textStyle: TextStyle(fontSize: 14)
    );
  }

  printPOS(){
    getBluetooth();
  }

  Future<void> getBluetooth() async {
    final List bluetooths = await BluetoothThermalPrinter.getBluetooths;
    print("Print $bluetooths");
    setState(() {
      availableBluetoothDevices = bluetooths;
    });
    print(availableBluetoothDevices);


  }

  Future<void> setConnect(String mac) async {
    final String result = await BluetoothThermalPrinter.connect(mac);
    print("state conneected $result");
    if (result == "true") {
      setState(() {
        connected = true;
      });

    }
  }

  Future<void> printTicket() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    bytes += generator.text('Bold text');
    bytes +=
        generator.text('Align left', styles: PosStyles(align: PosAlign.left));

    bytes += generator.cut();
    String isConnected = await BluetoothThermalPrinter.connectionStatus;
    if (isConnected == "true") {
      final result = await BluetoothThermalPrinter.writeText("ahmed \n ahmed");
    } else {
      //Hadnle Not Connected Senario
    }
  }


  _testTicket() async {

  }




}

