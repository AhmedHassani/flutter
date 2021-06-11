import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'acount/acount.dart';
import 'bloc_items/bolc_items_bloc.dart';
import 'cart_list.dart';
import 'models/items.dart';


class Cart extends StatefulWidget {
  final Bloc<BolcItemsEvent, BolcItemsState>  _bloc;
  Cart(this._bloc);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CartValues> listCarts;
  CartList _cartList ;
  TextEditingController _editingController =TextEditingController();
  double sum;
  int _intstate=0;
  String typePrice="";
  @override
  Widget build(BuildContext context) {

    _cartList = Provider.of<CartList>(context, listen: false);
    setState(() {
       listCarts=Provider.of<CartList>(context, listen: false).items;
       sum= Provider.of<CartList>(context, listen: false).sum;
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("فاتوره الحساب",
            style:GoogleFonts.tajawal(
              textStyle:TextStyle(
                  color: Colors.white,
                  fontWeight:FontWeight.bold,
                  fontSize: 16),)
        ),
        leading:Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context,"back");
            },
          ),
        ),
        actions: [
          Align(
            child: IconButton(
              icon: Icon(Icons.account_balance_wallet,color: Colors.white,),
              onPressed: () async {
                String received;
                if(Provider.of<CartList>(context, listen: false).items.length>0){
                  received = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Acount(widget._bloc)));
                }
                if(received=="back2"){
                  setState(() {
                    Provider.of<CartList>(context, listen: false).sum;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
                color: Color.fromRGBO(232, 87,102,1),
                height: 60,
                child:Row(
                  children: [
                    Expanded(
                        child: Container(
                          decoration:BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 2, color: Colors.white),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right:9),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "${_setMoneyFormatt(context.read<CartList>().sum)}"+" = "+"المجموع الكلي",
                                style:GoogleFonts.tajawal(
                                  textStyle:TextStyle(
                                    color: Colors.white,
                                    fontWeight:FontWeight.bold,
                                    fontSize: 14,
                                  ),),
                              ),
                            ),
                          ),
                        )),
                    Container(
                      width: 70,
                      child: FlatButton(
                        onPressed: () async {
                          if(Provider.of<CartList>(context, listen: false).items.length>0){
                             String received = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Acount(widget._bloc)));
                           if(received=="back2"){
                            setState(() {
                              Provider.of<CartList>(context, listen: false).sum;
                            });
                          }}
                        },
                        child: Text(
                          "متابعه",
                          style:GoogleFonts.tajawal(
                            textStyle:TextStyle(
                              color: Colors.white,
                              fontWeight:FontWeight.bold,
                              fontSize: 10,
                            ),),
                        ),
                      ),
                    ),

                  ],
                ))
          ),
          Expanded(
              child:viewCart(context,listCarts)
          )
        ],
      ),
    );
  }
  viewCart(context,List<CartValues> listCarts){
    if(listCarts==null || listCarts.length==0){
      return Center(
        child: Text("cart is  empty",style:GoogleFonts.tajawal(textStyle: TextStyle(fontSize: 18))),
      );
    }
    return  Column(
      children: [
        Expanded(
          child: ListView.separated(
              itemCount:listCarts.length,
              itemBuilder: (context,index){
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child:ListTile(
                    leading: listCarts[index].items.imgURL == null ? FlutterLogo():Image.network(listCarts[index].items.imgURL,width:75,height:75,),
                    title: Text(listCarts[index].items.itemNAME,style: GoogleFonts.tajawal(),),
                    trailing:Container(
                      width: 50,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        initialValue:"${_intstate == 0 ?listCarts[index].number:_intstate}" ,
                        onChanged: (value){
                          if(value.isNotEmpty && int.parse(value) != 0 && int.parse(value) > 0) {
                             setState(() {
                               CartList cartList = Provider.of<CartList>(
                                   context, listen: false);
                               cartList.upateNumebrItem(
                                   listCarts[index].items, int.parse(value),
                                   index);
                               cartList.sumtion();
                               cartList.itemsCount();
                             });
                             print(typePrice);
                          }
                        },
                      ),
                    ),
                    subtitle: Text(
                        "${PriceNumber(listCarts[index].items,listCarts[index].number)}"
                            " = ${TotalPriceItems(listCarts[index].items,listCarts[index].number)}",
                      style:GoogleFonts.tajawal(),
                    ),
                  ),
                  actions: [
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () =>_showSnackBar(context,"delete items ${listCarts[index].items.itemNAME}",listCarts[index]),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              }
          ),
        ),
      ],
    );
  }


  @override
  void initState() {
    getSetting();
  }

  Future<Void> getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      typePrice=prefs.getString("type");
    });

  }



  void _showSnackBar(BuildContext context, String text,CartValues item) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text,style: GoogleFonts.tajawal(),)));
    setState(() {
      CartList cartList = Provider.of<CartList>(context, listen: false);
      cartList.removeitem(item);
      cartList.sumtion();
      cartList.itemsCount();
    });

  }
  
  _setMoneyFormatt(double price){
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: price);
    return fmf.output.nonSymbol.replaceAll(RegExp(r'.00*$'), "");
  }

  String TotalPriceItems(Items sell,int num){
    getSetting();
    double price1=setPrice(sell,typePrice);
    return _setMoneyFormatt(price1*num);
  }

  String PriceNumber(Items sell,int num) {
    getSetting();
    double price1=setPrice(sell,typePrice);
    String fm =_setMoneyFormatt(price1);
    return "$fm x $num ";
  }

  TextEditingController setControllerDate(int number) {
    _editingController.text="$number";
    return _editingController;
  }
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
