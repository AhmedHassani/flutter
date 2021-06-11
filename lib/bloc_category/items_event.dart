part of 'items_bloc.dart';

@immutable
abstract class ItemsEvent {}

class FetchCategory extends ItemsEvent{
    FetchCategory();
}


