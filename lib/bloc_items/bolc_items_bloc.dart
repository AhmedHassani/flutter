import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:simple_app/models/Barcode.dart';
import 'package:simple_app/models/items.dart';
import 'package:simple_app/models/vacount.dart';
import 'package:simple_app/repository/Items_repository.dart';

part 'bolc_items_event.dart';
part 'bolc_items_state.dart';

class BolcItemsBloc extends Bloc<BolcItemsEvent, BolcItemsState> {
  final ItemRepository repository;
  BolcItemsBloc(this.repository) : super(BolcItemsInitial());

  @override
  Stream<BolcItemsState> mapEventToState(BolcItemsEvent event,) async* {
    if(event is FetchItems){
      yield ItemsLoading();
      try {
        final items = await repository.getItemsCategory(event.code);
        yield ItemsLoaded(items);
      }catch(e){
        yield ItemsError("error load data");
      }
    }
    else if(event is FetchAllItems){
      yield ItemsAllLoading();
      try {
        final items = await repository.getRandomItem();
        yield ItemsAllLoaded(items);
      }catch(e){
        yield ItemsAllError("error load data");
      }
    }
    else if(event is FetchFlterItems){
      yield ItemsLoading();
      try {
        final items = await repository.Flter(event.code, event.unit, event.category);
        yield ItemsLoaded(items);
      }catch(e){
        print(e.toString());
        yield ItemsError("error load data");
      }
    }
    else if(event is FetchSearch){
      yield SearchLoading();
      try{
        final  items = await repository.getSearchItems(event.query);
        yield SearchLoaded(items);
      }catch(e){
        print(e.toString());
        yield SearchError("error load data");
      }
    }
    else if(event is FetchAcount){
      yield AcountLoading();
      try {
        final items = await repository.FindAllAcount();
        yield AcountLoaded(items);
      }catch(e){
        yield AcountError("error load data");
      }
    }else if(event is FetchSearchAcount){
      yield AcountLoading();
      try {
        final items = await repository.SearchAcount(event.query);
        yield AcountLoaded(items);
      }catch(e){
        yield AcountError("error load data");
      }
    }else if(event is FetchItemBarcode){
      yield ItemsBarcodeLoading();
      try {
        final items = await repository.FindByBarcode(event.barcode);
        yield ItemsBarcodeLoaded(items);
      }catch(e){
        yield ItemsBarcodeError("error load data");
      }
    } else if(event is FetchFindAllItem){
      yield ItemsLoading();
      try {
        final items = await repository.FindAllItem();
        yield ItemsLoaded(items);
      }catch(e){
        yield ItemsError("error load data");
      }
    }


  }
}
