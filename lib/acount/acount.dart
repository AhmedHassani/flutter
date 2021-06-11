import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_app/bloc_items/bolc_items_bloc.dart';
import 'package:simple_app/models/vacount.dart';
import 'package:simple_app/send/SendView.dart';

class Acount extends StatefulWidget {
  final Bloc<BolcItemsEvent, BolcItemsState>  _bloc;
  Acount(this._bloc);
  @override
  _AcountState createState() => _AcountState();
}

class _AcountState extends State<Acount> {
  TextEditingController _textFieldController = TextEditingController();
  GlobalKey<RefreshIndicatorState> refechkey;
  List<VAcount> listVcont= [];
  VAcount _acount=VAcount();
  @override
  Widget build(BuildContext context) {
    print(widget._bloc.state);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color.fromRGBO(232, 87,102,1),
        title:AnimatedSearchBar(
          label: "اختر العميل",
          labelStyle:GoogleFonts.tajawal(textStyle:TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
          searchStyle:GoogleFonts.tajawal(textStyle:TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white)) ,
          cursorColor: Colors.white,
          searchDecoration: InputDecoration(
            hintText: "Search",
            alignLabelWithHint: true,
            fillColor: Colors.white,
            focusColor: Colors.white,
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) async {
            if(value!=""){
              widget._bloc.add(FetchSearchAcount(value));
            }else if(value==""){
              widget._bloc.add(FetchAcount());
            }
          },
        ),
        leading:Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context,"back2");
            },
          ),
        ),
      ),
      body:RefreshIndicator(
        key:refechkey,
        onRefresh: () async{
          widget._bloc.add(FetchAcount());
        },
        child: Center(
          child: Center(
            child: BlocBuilder<BolcItemsBloc,BolcItemsState>(
              bloc: widget._bloc,
              builder: (context,state){
                if(state is AcountLoading){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }else if(state is AcountLoaded){
                  this.listVcont=state.items;
                  return Center(
                    child: load(context, state.items),
                  );
                }else if(state is AcountError){
                  return Center(
                      child:Text(
                          "no internet connection.try again",
                           style:GoogleFonts.tajawal(),
                      ),
                  );
                }
                return Center(
                  child: Text(
                      "not Found Account!",
                      style:GoogleFonts.tajawal(),
                  ),
                );
              },
            ),
          ),
        ),
      )
    );
  }


  @override
  void initState() {
    widget._bloc.add(FetchAcount());
    refechkey=GlobalKey<RefreshIndicatorState>();
  }

  load(BuildContext context, List<VAcount> items) {
      return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SentView(items[index])));
              },
              child: Card(
                    color:Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child:Align(
                                alignment: Alignment.centerLeft,
                                child:IconButton(
                                  icon: Icon(Icons.more_vert,size: 25,),
                                  onPressed: (){
                                    _displayTextInputDialog(context);
                                  },
                                )
                            )),
                            Expanded(child:Align(
                             alignment: Alignment.centerRight,
                             child:Padding(
                               padding: const EdgeInsets.only(bottom:0,right: 12,),
                               child: Text(
                                 items[index].accountNAME,
                                 style:GoogleFonts.tajawal(
                                   textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)
                                 ),
                                 textAlign: TextAlign.right,
                                ),
                             ),)
                            ),

                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child:Padding(
                                  padding: const EdgeInsets.only(top: 8,right: 12),
                                  child:Text(
                                    "${_setMoneyFormatt(items[index].balance)} = "+"الرصيد",
                                     style:GoogleFonts.tajawal(),
                                     textAlign:TextAlign.right,
                                  ),
                                ),),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child:Padding(
                                  padding: const EdgeInsets.only(top: 8,right: 12),
                                  child:Text(
                                    "${_setMoneyFormatt(items[index].balanceIQ)} = "+"الرصيد العراقي",
                                     style:GoogleFonts.tajawal(),
                                     textAlign:TextAlign.right,
                                  ),
                                ),),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child:Padding(
                                  padding: const EdgeInsets.only(top: 8,right: 12,bottom: 10),
                                  child:Text(
                                    "${Total(items[index].balance,items[index].balanceIQ)} = "+"المجموع الكلي ",
                                    style:GoogleFonts.tajawal(
                                        textStyle: TextStyle()),
                                    textAlign: TextAlign.right,
                                  ),
                                ),),
                            )
                          ],
                        ),
                      ],
                    ),
              ),
            );
        }
      );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,

        builder: (context) {
          return AlertDialog(
            title: Text(
                'آدخال المبلغ',
                 style:GoogleFonts.tajawal(),
            ),
            content: Container(
              height: 145,
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                    },
                    controller: _textFieldController,
                    keyboardType:TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "المبلغ",
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
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                    child: Text(
                      'رجوع',
                      style:GoogleFonts.tajawal(textStyle:TextStyle(color: Colors.black87)),
                    ),)
              ),
              Align(
            alignment: Alignment.bottomRight,
            child:RaisedButton(
              onPressed: (){
                print(_textFieldController.text);
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
  _setMoneyFormatt(double price){
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: price);
    return fmf.output.nonSymbol.replaceAll(RegExp(r'.00*$'), "");
  }

  Total(double balance, double balanceIQ) {
    return _setMoneyFormatt((balance-balanceIQ));
  }





}
