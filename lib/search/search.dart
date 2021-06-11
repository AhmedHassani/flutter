import 'dart:ffi';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/bloc_items/bolc_items_bloc.dart';
import 'package:simple_app/models/items.dart';
import '../cart.dart';
import '../cart_list.dart';

int numchart;
class DataSearch extends SearchDelegate<Items>{
  final Bloc<BolcItemsEvent, BolcItemsState>  _bloc;
  DataSearch(this._bloc);


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: (){
            query="";
          })
    ];
  }




  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
           close(context,Items(itemNAME:"backsearh"));
        });
  }

  @override
  Widget buildResults(BuildContext context) {
     _bloc.add(FetchSearch(query));
      return SearchView(_bloc);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _bloc.add(FetchAllItems());
    if(query.length==0 || query=="") {
      return Container(
        child: BlocBuilder<BolcItemsBloc, BolcItemsState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is ItemsAllLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ItemsAllLoaded) {
              print(state.items.length);
              if(state.items.length==0)
                return Center(
                  child: Text("Not Found $query"),
                );
              return Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10,25,10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "عمليات البحث الرائجة",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              query=state.items[index].itemNAME;
                            },
                            title:Align(
                              alignment:Alignment.centerRight,
                              child:Text(state.items[index].itemNAME),
                            ),
                            leading: state.items[index].imgURL == null ? FlutterLogo():Image.network(state.items[index].imgURL,width:75,height:75,),
                            trailing: Icon(Icons.search)
                            ,);
                        },
                      ),
                    )
                  ],
                ),
              );
            } else if (state is ItemsAllError) {
              return Center(
                  child: Text("Not Found this ")
              );
            }
            return Center(
              child: Text("Search..."),
            );
          },
        ),
      );
    }else if(query.length>0){
      return Center(
        child: Center(
          child: Text(""),
        ),
      );
      print("query : $query");
    }
  }
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      textTheme: TextTheme(title: TextStyle( color: Colors.black87, fontSize: 15,height:1),),
      appBarTheme: AppBarTheme(
        color: Color.fromRGBO(232, 87,102,1),
        elevation: 0.0
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: Colors.white,
        hoverColor: Color.fromRGBO(232, 87,102,1),
        border: InputBorder.none,
        isCollapsed: true,
        contentPadding: EdgeInsets.only(left: 5,right: 5,bottom: 0,top: 0),
        labelStyle: TextStyle(color: Colors.black87),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(14.7),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(14.7),
        ),

      ),



    );
  }
}



class SearchView extends StatefulWidget {
  var _bloc;
  SearchView(this._bloc);


  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String _typePrice;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<BolcItemsBloc, BolcItemsState>(
        bloc: widget._bloc,
        builder: (context, state)  {
          if (state is SearchLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SearchLoaded) {
            return Column(
              children: [
                   Container(
                     height: 50,
                     width: double.infinity,
                     color:Color.fromRGBO(232, 87,102,1),
                     child:Row(
                       children: [
                         Expanded(
                           child: Padding(
                             padding: const EdgeInsets.all(10.0),
                             child: Align(
                               alignment: Alignment.centerLeft,
                               child: Expanded(
                                 child: Row(
                                   children: [
                                     Text("Total Price : " ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                     Text("${_setMoneyFormatt(Provider.of<CartList>(context, listen: false).sum).replaceAll(RegExp(r'.00*$'), "")}" ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
                                   ],
                                 ),
                               ),
                             ),
                           ),
                         ),
                         Padding(
                           padding: const EdgeInsets.all(2.0),
                           child: Align(
                             alignment: Alignment.centerRight,
                             child: Badge(
                                 position: BadgePosition.topEnd(top: -4, end:4),
                                 badgeContent: Text("${Provider.of<CartList>(context, listen: false).itemsCount()}",style:TextStyle(color: Colors.white),),
                                 child: IconButton(
                                     icon: Icon(Icons.shopping_cart,size: 30,color: Colors.white,),
                                     onPressed: () async {
                                       String received = await Navigator.push(
                                           context,
                                           MaterialPageRoute(builder: (context) => Cart(widget._bloc)
                                           ));
                                     })
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                   Expanded(
              child: ListView.separated(
              itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          Provider.of<CartList>(context, listen: false).addCart(state.items[index],_typePrice);
                          Provider.of<CartList>(context, listen: false).sumtion();
                          Provider.of<CartList>(context, listen: false).itemsCount();
                        });
                      },
                      title:Align(
                        alignment:Alignment.centerRight,
                        child:Text(state.items[index].itemNAME),
                      ),
                      trailing:state.items[index].imgURL == null ? FlutterLogo():Image.network(state.items[index].imgURL,width:75,height:75,),
                      leading: Text(
                        "${_setMoneyFormatt(state.items[index].priceSALE1).replaceAll(RegExp(r'.00*$'), "")}"
                        ,style: TextStyle(color: Colors.black),),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  }
              ),
          ),
              ],
            );
          } else if (state is SearchError) {
            return Center(
                child: Text("Not Found this ")
            );
          }
          return Center(
            child: Text(""),
          );
        },
      ),
    );;



  }


  _setMoneyFormatt(double price){
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: price);
    return fmf.output.nonSymbol;
  }

  Future<Void> getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _typePrice=prefs.getString("type");
  }

}











