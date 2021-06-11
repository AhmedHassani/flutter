import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/models/Category.dart';
import 'package:simple_app/models/items.dart';
import 'package:simple_app/models/vacount.dart';
import 'package:http/http.dart' as http;


abstract class ItemRepository {
   Future<List<Items>> getItemsCategory(var code);
   Future<List<Category>> getCatgory();
   Future<List<Items>> getRandomItem();
   Future<List<Items>> getSearchItems(String query);
   Future<List<Items>> Flter(int code ,int unit,int category);
   Future<List<VAcount>> FindAllAcount();
   Future<List<VAcount>> SearchAcount(String query);
   Future<String> FindBarcode(String brcode);
   Future<List<Items>> FindByBarcode(String code);
   Future<List<Items>> FindAllItem();
   Future<String> Login(String username,String password);
}

class ItemRepositoryIMP extends ItemRepository{
  String _IP;
  String _PORT;
  @override
  Future<List<Items>> getItemsCategory(var code) async {

     SharedPreferences prefs = await SharedPreferences.getInstance();
     var url = Uri.http("${prefs.getString("ip")}:${prefs.getString("port")}",'/iraqsoft/speedoo/api/v1/itemsapp/code/$code');
     final  response = await get(url,
         headers: {
         'Content-Type': 'application/json',
         'Accept': 'application/json',
         'Authorization': 'Bearer ${prefs.getString('token')}',
         }
     );
     if(response.statusCode==200){
       String body =utf8.decode(response.bodyBytes);
       final parse = json.decode(body).cast<Map<String,dynamic>>();
       return parse.map<Items>((item)=>Items.fromJson(item)).toList();
     }else{
        throw Exception("Filed to load data");
     }
  }

  @override
  Future<List<Category>> getCatgory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http("${prefs.getString("ip")}:${prefs.getString("port")}",'/iraqsoft/speedoo/api/v1/category');
    final  response = await get(url,
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${prefs.getString('token')}',
        }
    );
    if(response.statusCode==200){
      String body =utf8.decode(response.bodyBytes);
      final parse = json.decode(body).cast<Map<String,dynamic>>();
      return parse.map<Category>((item)=>Category.fromJson(item)).toList();
    }else{
      throw Exception("Filed to load data");
    }
  }

  @override
  Future<List<Items>> getRandomItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http("${prefs.getString("ip")}:${prefs.getString("port")}",'/iraqsoft/speedoo/api/v1/itemsapp/random');
    final  response = await get(url,headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('token')}',
    });
    if(response.statusCode==200){
      String body =utf8.decode(response.bodyBytes);
      final parse = json.decode(body).cast<Map<String,dynamic>>();
      return parse.map<Items>((item)=>Items.fromJson(item)).toList();
    }else{
      throw Exception("Filed to load data");
    }
  }

  @override
  Future<List<Items>> getSearchItems(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http("${prefs.getString("ip")}:${prefs.getString("port")}",'/iraqsoft/speedoo/api/v1/itemsapp/search/'+query);
    final  response = await get(url,headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('token')}',
    });
    if(response.statusCode==200){
      String body =utf8.decode(response.bodyBytes);
      final parse = json.decode(body).cast<Map<String,dynamic>>();
      return parse.map<Items>((item)=>Items.fromJson(item)).toList();
    }else{
      throw Exception("Filed to load data");
    }
  }

  ///iraqsoft/speedoo/api/v1/itemsapp/filter/1/1

  Future<Void> getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _IP = prefs.getString("ip");
    _PORT = prefs.getString("port");
  }

  @override
  Future<List<Items>> Flter(int code, int unit,int category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http("${prefs.getString("ip")}:${prefs.getString("port")}",'iraqsoft/speedoo/api/v1/itemsapp/filter/$code/$unit/$category');
    final  response = await get(url,headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('token')}',
    });
    if(response.statusCode==200){
      String body =utf8.decode(response.bodyBytes);
      final parse = json.decode(body).cast<Map<String,dynamic>>();
      return parse.map<Items>((item)=>Items.fromJson(item)).toList();
    }else{
      throw Exception("Filed to load data");
    }
  }

  @override
  Future<List<VAcount>> FindAllAcount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http("${prefs.getString("ip")}:${prefs.getString("port")}",'/iraqsoft/speedoo/api/v1/account/');
    final  response = await get(url,headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('token')}',
    });
    if(response.statusCode==200){
      String body =utf8.decode(response.bodyBytes);
      final parse = json.decode(body).cast<Map<String,dynamic>>();
      return parse.map<VAcount>((item)=>VAcount.fromJson(item)).toList();
    }else{
      throw Exception("Filed to load data");
    }
  }
  ///iraqsoft/speedoo/api/v1/account/search/**
 @override
  Future<List<VAcount>> SearchAcount(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http("${prefs.getString("ip")}:${prefs.getString("port")}",'iraqsoft/speedoo/api/v1/account/search/$query');
    final  response = await get(url,headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('token')}',
    });
    if(response.statusCode==200){
      String body =utf8.decode(response.bodyBytes);
      final parse = json.decode(body).cast<Map<String,dynamic>>();
      return parse.map<VAcount>((item)=>VAcount.fromJson(item)).toList();
    }else{
      throw Exception("Filed to load data");
    }
  }
  ///iraqsoft/speedoo/api/v1/barcode/getbarcode/000000
  @override
  Future<String> FindBarcode(String brcode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http("${prefs.getString("ip")}:${prefs.getString("port")}",'iraqsoft/speedoo/api/v1/barcode/getbarcode/$brcode}');
    final  response = await get(url,headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('token')}',
    });
    print(response.body);
    if(response.statusCode==200){
      String body =utf8.decode(response.bodyBytes);
      final parse = json.decode(body);
      return parse['item_CODE'];
    }else{
      throw Exception("Filed to load data");
    }
  }

  @override
  Future<List<Items>> FindByBarcode(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http("${prefs.getString("ip")}:${prefs.getString("port")}",'/iraqsoft/speedoo/api/v1/itemsapp/barcode/$code');
    final  response = await get(url,headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('token')}',
    });
    if(response.statusCode==200){
      String body =utf8.decode(response.bodyBytes);
      final parse = json.decode(body).cast<Map<String,dynamic>>();
      return parse.map<Items>((item)=>Items.fromJson(item)).toList();
    }else{
      throw Exception("Filed to load data");
    }
  }

  @override
  Future<List<Items>> FindAllItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http("${prefs.getString("ip")}:${prefs.getString("port")}",'/iraqsoft/speedoo/api/v1/itemsapp/get');
    final  response = await get(url,headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('token')}',
    });
    if(response.statusCode==200){
      String body =utf8.decode(response.bodyBytes);
      final parse = json.decode(body).cast<Map<String,dynamic>>();
      return parse.map<Items>((item)=>Items.fromJson(item)).toList();
    }else{
      throw Exception("Filed to load data");
    }
  }

  @override
  Future<String> Login(String username,String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map data = {'username':username,'password':password};
    String body = json.encode(data);
    http.Response response = await http.post(
      Uri.http("${prefs.getString("ip")}:${prefs.getString("port")}",'/iraqsoft/speedoo/api/v1/auth'),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    print(response.body);
    if(response.statusCode==200){
       return response.body;
    }else{
      throw Exception(" Not Login ");
    }
  }
}


