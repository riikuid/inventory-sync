// lib/features/inventory/presentation/bloc/company_item_list_cubit/company_item_list_state.dart
part of 'company_item_list_cubit.dart';

abstract class CompanyItemListState extends Equatable {
  const CompanyItemListState();

  @override
  List<Object?> get props => [];
}

class CompanyItemListInitial extends CompanyItemListState {}

class CompanyItemListLoading extends CompanyItemListState {}

class CompanyItemListLoaded extends CompanyItemListState {
  final List<CompanyItemSummary> items;
  const CompanyItemListLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class CompanyItemListEmpty extends CompanyItemListState {}

class CompanyItemListError extends CompanyItemListState {
  final String message;
  const CompanyItemListError(this.message);

  @override
  List<Object?> get props => [message];
}
