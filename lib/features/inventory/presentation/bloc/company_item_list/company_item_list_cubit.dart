// lib/features/inventory/presentation/bloc/company_item_list_cubit/company_item_list_cubit.dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/inventory_repository.dart';
import '../../../../../core/db/daos/company_item_dao.dart';

part 'company_item_list_state.dart';

class CompanyItemListCubit extends Cubit<CompanyItemListState> {
  final InventoryRepository repository;
  StreamSubscription? _sub;

  CompanyItemListCubit(this.repository) : super(CompanyItemListInitial());

  void watch({String? productId}) {
    emit(CompanyItemListLoading());

    _sub?.cancel();
    _sub = repository
        .watchCompanyItems(productId: productId)
        .listen(
          (items) {
            emit(CompanyItemListLoaded(items));
          },
          onError: (e) {
            emit(CompanyItemListError(e.toString()));
          },
        );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  // Future<void> load(String productId) async {
  //   emit(CompanyItemListLoading());
  //   try {
  //     final items = await repository.getCompanyItemsByProduct(productId);
  //     if (items.isEmpty) {
  //       emit(CompanyItemListEmpty());
  //     } else {
  //       emit(CompanyItemListLoaded(items));
  //     }
  //   } catch (e) {
  //     emit(CompanyItemListError(e.toString()));
  //   }
  // }
}
