// lib/features/inventory/presentation/bloc/company_item_list_cubit/company_item_list_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/inventory_repository.dart';

part 'company_item_list_state.dart';

class CompanyItemListCubit extends Cubit<CompanyItemListState> {
  final InventoryRepository repository;

  CompanyItemListCubit(this.repository) : super(CompanyItemListInitial());

  Future<void> load(String productId) async {
    emit(CompanyItemListLoading());
    try {
      final items = await repository.getCompanyItemsByProduct(productId);
      if (items.isEmpty) {
        emit(CompanyItemListEmpty());
      } else {
        emit(CompanyItemListLoaded(items));
      }
    } catch (e) {
      emit(CompanyItemListError(e.toString()));
    }
  }
}
