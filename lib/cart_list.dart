

import 'package:flutter/foundation.dart';
import 'package:simple_app/models/items.dart';

class CartList with ChangeNotifier, DiagnosticableTreeMixin{
  List<CartValues> _items=[];
  String _type;
  double _sum=0;
  isFound(Items insertItem){
    for(CartValues cartValues in _items){
      if(cartValues._items.id==insertItem.id){
        notifyListeners();
        return true;
      }
    }
    notifyListeners();
    return false;
  }
  upateItem(Items insertItem){
    for(CartValues cartValues in _items){
      if(cartValues._items.id==insertItem.id){
          print(cartValues.number);
          int num =cartValues.number+1;
          _items.remove(cartValues);
          _items.add(new CartValues(num,insertItem));
      }
    }
    notifyListeners();
  }

  upateNumebrItem(Items insertItem,num,index){
    for(CartValues cartValues in _items){
      if(cartValues._items.id==insertItem.id){
        _items.remove(cartValues);
        _items.insert(index,new CartValues(num,insertItem));
      }
    }
    notifyListeners();
  }

  void removeitem(CartValues item){
    _items.remove(item);
    sumtion();
    notifyListeners();
  }

  decrment(Items insertItem){
    for(CartValues cartValues in _items){
      if(cartValues._items.id==insertItem.id){
        int num =cartValues.number-1;
        _items.remove(cartValues);
        _items.add(new CartValues(num,insertItem));
      }
    }
    notifyListeners();
  }



  int itemsCount(){
    return _items.length;
  }


  void addCart(Items insertItem,String type) {
        _type=type;
        if(isFound(insertItem)){
          upateItem(insertItem);
        }else{
          _items.add(new CartValues(1,insertItem));
        }
      notifyListeners();
  }

  void sumtion(){
    _sum=0;
    for(CartValues s in  _items)
      _sum= (_sum+setPrice(s.items,_type)) * s.number;
    notifyListeners();
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


  double get sum => _sum;

  List<CartValues> get items => _items;
}

class CartValues {
  int _number;
  Items _items;

  CartValues(this._number, this._items);

  int get number => _number;

  set number(int value) {
    _number = value;
  }

  Items get items => _items;

  set items(Items value) {
    _items = value;
  }
}