import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:simple_app/models/Category.dart';
import 'package:simple_app/models/items.dart';
import 'package:simple_app/repository/Items_repository.dart';

part 'items_event.dart';
part 'items_state.dart';

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ItemRepository repository;
  ItemsBloc(this.repository) : super(ItemsInitial());

  @override
  Stream<ItemsState> mapEventToState(ItemsEvent event,) async* {
       if(event is FetchCategory){
          yield CategoryLoading();
          try{
            final category = await repository.getCatgory();
            yield CategoryLoaded(category);
          }catch(e){
            print(e);
            yield CategoryError(e.toString());
          }
       }
  }
}
