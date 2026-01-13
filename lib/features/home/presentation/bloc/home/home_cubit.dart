// lib/features/inventory/presentation/bloc/home/home_cubit.dart

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:inventory_sync_apps/core/db/daos/category_dao.dart';
import 'package:inventory_sync_apps/core/db/daos/company_item_dao.dart';
import 'package:inventory_sync_apps/features/inventory/data/inventory_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final InventoryRepository _repository;

  StreamSubscription<List<CategorySummary>>? _categorySub;
  StreamSubscription<List<CompanyItemListRow>>? _companyItemSub;

  List<CategorySummary> _categories = const [];
  List<CompanyItemListRow> _companyItems = const [];

  HomeCubit(this._repository) : super(HomeLoading()) {
    _subscribeStreams();
  }

  void _subscribeStreams() {
    emit(HomeLoading());

    _categorySub = _repository.watchRootCategories().listen(
      (cats) {
        _categories = cats;
        _emitCombined();
      },
      onError: (error, _) {
        emit(HomeError(error.toString()));
      },
    );

    _companyItemSub = _repository.watchCompanyItems().listen(
      (items) {
        _companyItems = items;
        _emitCombined();
      },
      onError: (error, _) {
        emit(HomeError(error.toString()));
      },
    );
  }

  void _emitCombined() {
    // Jangan override state error
    if (state is HomeError) return;

    emit(HomeLoaded(categories: _categories, companyItems: _companyItems));
  }

  Future<void> refreshFromLocal() async {
    // Karena kita pakai stream dari Drift, data akan auto-refresh ketika sync.
    // Di sini kita cukup emit ulang state Loaded supaya RefreshIndicator selesai.
    _emitCombined();
  }

  @override
  Future<void> close() {
    _categorySub?.cancel();
    _companyItemSub?.cancel();
    return super.close();
  }
}
