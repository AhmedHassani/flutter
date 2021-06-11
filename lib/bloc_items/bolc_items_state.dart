part of 'bolc_items_bloc.dart';

@immutable
abstract class BolcItemsState {}

class BolcItemsInitial extends BolcItemsState {}

class ItemsLoading extends BolcItemsState{}
class ItemsLoaded extends BolcItemsState{
  final List<Items> items;
  ItemsLoaded(this.items);
}
class ItemsError extends BolcItemsState{
  final String massage;
  ItemsError(this.massage);
}
//get All items state
class ItemsAllLoading extends BolcItemsState{}
class ItemsAllLoaded extends BolcItemsState{
  final List<Items> items;
  ItemsAllLoaded(this.items);
}
class ItemsAllError extends BolcItemsState{
  final String massage;
  ItemsAllError(this.massage);
}
//Search
class SearchLoading extends BolcItemsState{}
class SearchLoaded extends BolcItemsState{
  final List<Items> items;
  SearchLoaded(this.items);
}
class SearchError extends BolcItemsState{
  final String massage;
  SearchError(this.massage);
}

//Acount state findAll
class AcountLoading extends BolcItemsState{}
class AcountLoaded extends BolcItemsState{
  final List<VAcount> items;
  AcountLoaded(this.items);
}
class AcountError extends BolcItemsState{
  final String massage;
  AcountError(this.massage);
}
//Acount Search state findAll
class BarcodeLoading extends BolcItemsState{}
class BarcodeLoaded extends BolcItemsState{
  final Barcode barcode;
  BarcodeLoaded(this.barcode);
}
class BarcodeError extends BolcItemsState{
  final String massage;
  BarcodeError(this.massage);
}

class ItemsBarcodeLoading extends BolcItemsState{}
class ItemsBarcodeLoaded extends BolcItemsState{
  final List<Items> items;
  ItemsBarcodeLoaded(this.items);
}
class ItemsBarcodeError extends BolcItemsState{
  final String massage;
  ItemsBarcodeError(this.massage);
}
//Login State