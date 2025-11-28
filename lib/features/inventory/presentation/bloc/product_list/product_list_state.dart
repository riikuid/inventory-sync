// lib/features/inventory/presentation/bloc/product_list_cubit/product_list_state.dart
part of 'product_list_cubit.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<ProductSummary> products;
  const ProductListLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductListEmpty extends ProductListState {}

class ProductListError extends ProductListState {
  final String message;
  const ProductListError(this.message);

  @override
  List<Object?> get props => [message];
}
