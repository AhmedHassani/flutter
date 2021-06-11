import 'dart:convert';
import 'dart:ffi';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:frefresh/frefresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/bloc_category/items_bloc.dart';
import 'package:simple_app/bloc_items/bolc_items_bloc.dart';
import 'package:simple_app/home/dialog.dart';
import 'package:simple_app/login_view.dart';
import 'package:simple_app/models/Category.dart';
import 'package:simple_app/models/items.dart';
import 'package:simple_app/repository/Items_repository.dart';
import 'package:simple_app/search/search.dart';
import 'package:simple_app/setting/seetting.dart';
import '../ItemsProvieder.dart';
import '../cart.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import '../cart_list.dart';



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
   FRefreshController controller1;
   String valueChose;
   List<Items> itmes=null;
   bool isload=false;
   String typePrice;
   String hint = "كل مجموعات";
   BolcItemsState _state;
   ItmesProvider _itmesProvider;
   String _BARCODE="";
   GlobalKey<RefreshIndicatorState> refechkey;
   BolcItemsBloc _itemsBloc;
   String _TOKEN="";
   @override
  Widget build(BuildContext context) {
     _itmesProvider=Provider.of<ItmesProvider>(context, listen: false);
     _itemsBloc = BlocProvider.of<BolcItemsBloc>(context);
     return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Speedoo",
          style: GoogleFonts.tajawal(textStyle:TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 20),),),
        leading:Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              String received = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Setting()));
                 if(received=="backSetting"){
                    print(received);
                    setState(() {
                    getSetting();
                    BlocProvider.of<ItemsBloc>(context).add(FetchCategory());
                    Provider.of<CartList>(context, listen: false).sum;
                    received="";
                 });
              }
            },
          ),
        ),

        actions: [
          Align(
            alignment: Alignment.centerLeft,
            child:IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("token", "");
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
                    )
                    ));
              },
              icon: Icon(Icons.login,color: Colors.white,),
            ) ,
          ),
          Align(
            alignment: Alignment.centerRight,
            child:Badge(
              position: BadgePosition.topEnd(top: -4, end:4),
              badgeContent: Text("${Provider.of<CartList>(context, listen: false).itemsCount()}",
                style:TextStyle(color: Colors.white),),
              child: IconButton(
                icon: Icon(Icons.shopping_cart,size: 28,),
                onPressed: () async {
                  String received = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cart(_itemsBloc)
                  ));
                  if(received=="back"){
                   setState(() {
                     Provider.of<CartList>(context, listen: false).sum;
                     received="";
                   });
                  }
                },
              ),
           ),
          ),
        ],
      ),
      body:RefreshIndicator(
        key:refechkey,
        onRefresh: ()async{
          BlocProvider.of<ItemsBloc>(context).add(FetchCategory());
         // _itemsBlodc.add(FetchFindAllItem());
        },
        child: Center(
          child: BlocBuilder<ItemsBloc,ItemsState>(
            builder: (context,state){
              if(state is CategoryLoading){
                 return CircularProgressIndicator();
              }else if(state is CategoryLoaded){
                   //valueChose=state.category[0].categoryCODE;
                   if(itmes==null){
                     _itemsBloc.add(FetchFindAllItem());
                   }
                  return loadMainWindow(state.category,Provider.of<CartList>(context, listen: false).sum,itmes,valueChose);
              }else if(state is CategoryError){
                 return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Image.asset("image/noconect.png" ,width: 75,),
                       Center(child:Text("محاوله ثانية"+"."+"لا يوجد اتصال بالإنترنت",style: GoogleFonts.tajawal(),)),
                       Center(
                         child: IconButton(
                           onPressed: (){
                             BlocProvider.of<ItemsBloc>(context).add(FetchCategory());
                           },
                           icon: Icon(Icons.settings_backup_restore_rounded),
                         ),
                       )
                     ]);
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      )
    );

  }


  
  Widget loadMainWindow(List<Category> category,sum,List<Items> items,typeCategorey){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10,left: 10,bottom: 10,top: 10),
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
                         String received = await Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => Cart(_itemsBloc)
                             ));
                         if(received=="back"){
                           setState(() {
                             Provider.of<CartList>(context, listen: false).sum;
                             received="";
                           });
                         }
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
            )),
          ),
        Container(
          margin: EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
              )),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: DropdownButton(
                    style: TextStyle(wordSpacing: 2,color: Colors.black),
                    underline: SizedBox(),
                    isExpanded: true,
                    hint:Text(hint),
                    value: valueChose,
                    onChanged: (newValue){
                      setState(() {
                         valueChose=newValue;
                          if(int.parse(newValue)==200){
                            _itemsBloc.add(FetchFindAllItem());
                          }else{
                            _itemsBloc.add(FetchItems(int.parse(newValue)));
                          }
                      });
                    },
                    items: myCategory(category).map((item)  {
                      return DropdownMenuItem(
                          value:"${item.categoryCODE}",
                          child:Text(item.categoryNAME,style: GoogleFonts.tajawal(),)
                      );
                    }).toList(),
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: (){
                   Future<Items> it = showSearch(
                       context: context,
                       delegate:DataSearch(
                           BlocProvider.of<BolcItemsBloc>(context)
                       ));
                   it.then((value) => {
                     up(value, context),
                   });
                  }
              ),
              IconButton(
                  icon: Icon(Icons.filter_alt_outlined),
                  onPressed: (){
                      //_itemsBlodc.add(FetchItems(int.parse(valueChose)));
                      showDialog<DialogModel>(context: context, builder: (context) => DialogFilter(itmes,valueChose)).then((value) => {
                      Filter(value,int.parse(valueChose)),
                    });
                  }
              ),
              /*
                // Fetch Barcode from Api  by Sacn barcode 
                // Send Barcode to FectItemsByCode  
                // find add item get from FectItemBarcode  in card 
               */
              IconButton(
                  icon: Icon(Icons.camera_alt_outlined),
                  onPressed: (){
                    getBatCode();
                  }
              ),
            ],
          ),
        ),
        Expanded(
            child:BlocBuilder<BolcItemsBloc,BolcItemsState>(
              builder: (context,state){
                if(state is ItemsLoading){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }else if(state is ItemsLoaded){
                  return Center(
                    child: loadItems(context,state.items),
                  );
                }else if(state is ItemsError){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("image/noconect.png" ,width: 75,),
                      Center(child:Text("لا يوجد اتصال بالإنترنت",style: GoogleFonts.tajawal(),)),
                      Center(
                        child: IconButton(
                          onPressed: (){
                            BlocProvider.of<ItemsBloc>(context).add(FetchCategory());
                          },
                          icon: Icon(Icons.settings_backup_restore_rounded),
                        ),
                      )
                    ]);
                }else if(state is ItemsBarcodeLoading){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text("جاي اضافه ماده بواسطه الباراكود",style:GoogleFonts.tajawal(
                          textStyle: TextStyle(fontSize: 18)
                        ),)
                      ],
                    ),
                  );
                }
                return this.itmes!=[] ?loadItems(context,this.itmes): Center(
                  child: Text("Select Category places !",style: GoogleFonts.tajawal(),),
                );
              },
            ),

            //loadItems(Provider.of<ItmesProvider>(context, listen: false).items,context)
        ),
      ],
    );
  }
  /*
   //load view item
   //
   */

  Widget loadItems(context,List<Items> itmes){
       try {
         this.itmes = itmes;
         return ListView.separated(
           itemCount: itmes.length,
           separatorBuilder: (context, index) {
             return Divider();
           },
           itemBuilder: (context, index) {
             return ListTile(
               onTap: () {
                 context.read<CartList>().addCart(itmes[index],typePrice);
                 setState(() {
                   context.read<CartList>().sumtion();
                   Provider.of<CartList>(context, listen: false).sum;
                 });
                 Scaffold.of(context).showSnackBar(SnackBar(
                   content: Text(
                       "add item to cart ${itmes[index].itemNAME}",
                        style: GoogleFonts.tajawal(),
                   ),
                 ));
               },
               leading:Text(_setMoneyFormatt(
                   setPrice(itmes[index],typePrice)
               )),      //,
               title: Align(
                 alignment: Alignment.topRight,
                   child: Text(
                       itmes[index].itemNAME,
                       style: GoogleFonts.tajawal(),
                       textAlign:TextAlign.right ,
                   ),

               ),
               subtitle:Padding(
                 padding: EdgeInsets.only(right:0,top:3),
                 child:Align(
                   alignment: Alignment.topRight,
                   child: Text("${itmes[index].balance} = "+"الرصيد",
                     style: GoogleFonts.tajawal(),
                     textAlign:TextAlign.right ,
                   ),
                 ),
               ),
               trailing:loadImage(itmes[index])
             );
           },
         );
       }catch(e){
         print("not found items ");
       }
       return Center(
         child: Text(
           "Not Found Items !",
           style: GoogleFonts.tajawal(
             textStyle: TextStyle(color: Colors.black87,fontSize: 18),
           ),),
    );
  }
   @override
  void initState() {
     getSetting();
     refechkey=GlobalKey<RefreshIndicatorState>();
  }
  /*
   // set formatt price remove zero after point like 7.0=> 7
   */
  String _setMoneyFormatt(double price){
     FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: price);
     return fmf.output.nonSymbol.replaceAll(RegExp(r'.00*$'), "");
   }


  bool exist(List<Items> items, Items itm) {
     for(Items i in items){
       if(i==itm){
         return true;
       }
       return false;
     }
  }

  up(Items i,context){
     if(i.itemNAME=="backsearh"){
       setState(() {
         _itemsBloc.emit(ItemsLoaded(this.itmes));
       });
     }
  }
  /*
   // get type price
   */

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

   Future<Void> getSetting() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     typePrice=prefs.getString("type");
   }

   /*
    // Fetch Search by items code
    //
    */

  Filter(DialogModel model,int category) {
     if(model.code!=null && model.unit==null) {
       print("code");
       _itemsBloc.add(FetchFlterItems(model.code,-1,category));
     }else if(model.unit!=null && model.code==null){
       print("unit");
       _itemsBloc.add(FetchFlterItems(-1,model.unit,category));
     }else if(model.unit!=null && model.code!=null){
        print("code , unit ");
        _itemsBloc.add(FetchFlterItems(model.code,model.unit,category));
     }
  }

  _style(){
     return TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 14);
  }
   Future<bool> getBatCode() async {
     await Permission.camera.request();
     String barcode = await scanner.scan();
     if (barcode == null) {
       print('nothing return.');
     } else {
       SharedPreferences prefs = await SharedPreferences.getInstance();
       var url = Uri.http("${prefs.getString("ip")}:"
           "${prefs.getString("port")}",'iraqsoft/speedoo/api/v1/barcode/getbarcode/$barcode');
       final  response = await get(url, headers: {
         'Content-Type': 'application/json',
         'Accept': 'application/json',
         'Authorization': 'Bearer ${prefs.getString('token')}',
       });
       if(response.statusCode==200){
         String body =utf8.decode(response.bodyBytes);
         final parse = json.decode(body);
         _itemsBloc.add(FetchItemBarcode(parse['item_CODE']));
           AddCartByCode();
          return true;
       }else{
         throw Exception("Filed to load data");
       }
     }
     return true;
   }

   AddCartByCode() {
     int count  = 0;
     _itemsBloc.stream.listen((event) {
       if(event is ItemsBarcodeLoaded){
         count++;
         if(count==1) {
           context.read<CartList>().addCart(event.items.first, typePrice);
           context.read<CartList>().sum;
           setState(() {
             _itemsBloc.emit(ItemsLoaded(this.itmes));
           });
         }
       }
     });

  }

}

List<Category> myCategory(List<Category> category){
      int count =0;
      Category all = new Category(categoryCODE: 200,categoryNAME: "كل المجموعات",image: null,active: "1");
      for(Category c in category){
         if(c.categoryCODE==200){
           count =count+1;
         }
      }
      if(count==0)
        category.add(all);
      return category;
}

loadImage(Items items){
  return items.imgURL == "" ? Image.asset("image/logo.jpeg",height:60,width: 60,):Image.network(items.imgURL,height:60,width: 60,);
}









