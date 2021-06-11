part of 'bolc_items_bloc.dart';

@immutable
abstract class BolcItemsEvent {}


class FetchItems extends BolcItemsEvent{
  int code;
  FetchItems(this.code);
}

class FetchAllItems extends BolcItemsEvent{
  FetchAllItems();
}

class FetchFlterItems extends BolcItemsEvent{
  int code;
  int unit;
  int category;
  FetchFlterItems(this.code ,this.unit,this.category);
}


class FetchSearch extends BolcItemsEvent{
  String query;
  FetchSearch(this.query);
}

//Acount
class FetchAcount extends BolcItemsEvent{
  FetchAcount();
}
//Acount Search
class FetchSearchAcount extends BolcItemsEvent{
  String query;
  FetchSearchAcount(this.query);
}
//Barcode
class FetchBarcode extends BolcItemsEvent{
  String barcode;
  FetchBarcode(this.barcode);
}

class FetchItemBarcode extends BolcItemsEvent{
  String barcode;
  FetchItemBarcode(this.barcode);
}

class FetchFindAllItem extends BolcItemsEvent{
  FetchFindAllItem();
}

class FetchLogin extends BolcItemsEvent{
  String username;
  String password;
  FetchLogin(this.username,this.password);
}

