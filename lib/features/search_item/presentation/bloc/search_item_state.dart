part of 'search_item_cubit.dart';

abstract class SearchItemState extends Equatable {
  const SearchItemState();

  @override
  List<Object?> get props => [];
}

class SearchItemInitial extends SearchItemState {}

class SearchItemLoading extends SearchItemState {}

class SearchItemLoaded extends SearchItemState {
  final List<InventorySearchItem> items;
  const SearchItemLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class SearchItemEmpty extends SearchItemState {}

class SearchItemError extends SearchItemState {
  final String message;
  const SearchItemError(this.message);

  @override
  List<Object?> get props => [message];
}
