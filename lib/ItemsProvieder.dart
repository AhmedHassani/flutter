

import 'package:flutter/foundation.dart';
import 'package:simple_app/models/items.dart';


class ItmesProvider with ChangeNotifier, DiagnosticableTreeMixin{
  List<Items> _items=[];

   setitems(List<Items> value) {
     _items = value;
     notifyListeners();
   }
  List<Items> getItems(){
     return _items;
  }



}