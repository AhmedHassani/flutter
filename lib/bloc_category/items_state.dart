part of 'items_bloc.dart';

@immutable
abstract class ItemsState {}

class ItemsInitial extends ItemsState {}



class CategoryLoading extends ItemsState{}
class CategoryLoaded extends ItemsState{
  final List<Category> category;
  CategoryLoaded(this.category);
}


class CategoryError extends ItemsState{
  final String massage;
  CategoryError(this.massage);
}
