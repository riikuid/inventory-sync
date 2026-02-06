// lib/features/inventory/presentation/bloc/home/home_cubit.dart

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:inventory_sync_apps/core/user_storage.dart';

import 'package:inventory_sync_apps/core/db/daos/category_dao.dart';
import 'package:inventory_sync_apps/core/db/daos/company_item_dao.dart';
import 'package:inventory_sync_apps/core/db/app_database.dart';
import 'package:inventory_sync_apps/features/inventory/data/inventory_repository.dart';

import '../../../auth/models/user.dart';

part 'company_item_list_state.dart';

class CompanyItemListCubit extends Cubit<CompanyItemListState> {
  final InventoryRepository _repository;

  StreamSubscription<List<CategorySummary>>? _categorySub;
  StreamSubscription<List<CompanyItemListRow>>? _companyItemSub;

  List<CategorySummary> _categories = const [];
  List<CompanyItemListRow> _allCompanyItems = const []; // Store ALL items
  List<Warehouse> _warehouses = const [];

  // Local Filter State
  Set<String> _selectedCategoryIds = {};
  Set<String> _selectedWarehouseIds = {};
  Set<String> _selectedSectionIds = {};
  Set<String> _selectedLabelingStatus = {}; // New State
  String _searchQuery = '';

  CompanyItemListCubit(this._repository) : super(CompanyItemListLoading()) {
    _subscribeStreams();
  }

  void _subscribeStreams() async {
    User user = (await UserStorage.getUser())!;
    emit(CompanyItemListLoading());

    // Fetch Warehouses once
    _warehouses = await _repository.getAllWarehouses();

    _categorySub = _repository.watchRootCategories().listen(
      (cats) {
        _categories = cats;
        _emitCombined();
      },
      onError: (error, _) {
        emit(CompanyItemListError(error.toString()));
      },
    );

    List<String> userSectionIds =
        (user.sections != null && user.sections!.isNotEmpty)
        ? user.sections!.map((e) => e.id).whereType<String>().toList()
        : [];

    _companyItemSub = _repository
        .watchCompanyItems(sectionIds: userSectionIds)
        .listen(
          (items) {
            _allCompanyItems = items;
            _emitCombined();
          },
          onError: (error, _) {
            emit(CompanyItemListError(error.toString()));
          },
        );
  }

  void _emitCombined() {
    if (state is CompanyItemListError) return;

    // Apply Filters Locally
    List<CompanyItemListRow> filteredItems = _allCompanyItems.where((item) {
      // 1. Category Filter
      if (_selectedCategoryIds.isNotEmpty) {
        if (item.categoryId == null ||
            !_selectedCategoryIds.contains(item.categoryId)) {
          return false;
        }
      }

      // 2. Warehouse Filter
      if (_selectedWarehouseIds.isNotEmpty) {
        if (item.warehouseId == null ||
            !_selectedWarehouseIds.contains(item.warehouseId)) {
          return false;
        }
      }

      // 3. Section Filter
      if (_selectedSectionIds.isNotEmpty) {
        if (item.sectionId == null ||
            !_selectedSectionIds.contains(item.sectionId)) {
          return false;
        }
      }

      // 4. Labeling Status Filter
      if (_selectedLabelingStatus.isNotEmpty) {
        // If both are selected, skip filter (all shown)
        // Only if 1 is selected do we filter
        if (_selectedLabelingStatus.length == 1) {
          final showLabeled = _selectedLabelingStatus.contains('labeled');
          final showUnlabeled = _selectedLabelingStatus.contains('unlabeled');

          if (showLabeled && !item.isLabeled) return false;
          if (showUnlabeled && item.isLabeled) return false;
        }
      }

      // 4. Search Filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = item.productName.toLowerCase().contains(query);
        final matchesCode = item.companyCode.toLowerCase().contains(query);
        if (!matchesName && !matchesCode) {
          return false;
        }
      }

      return true;
    }).toList();

    emit(
      CompanyItemListLoaded(
        categories: _categories,
        companyItems: filteredItems,
        warehouses: _warehouses,
        selectedCategoryIds: _selectedCategoryIds,
        selectedWarehouseIds: _selectedWarehouseIds,
        selectedSectionIds: _selectedSectionIds,
        selectedLabelingStatus: _selectedLabelingStatus,
        searchQuery: _searchQuery,
      ),
    );
  }

  // Filter Actions
  void updateSearch(String query) {
    _searchQuery = query;
    _emitCombined();
  }

  void toggleCategoryFilter(String categoryId) {
    if (_selectedCategoryIds.contains(categoryId)) {
      _selectedCategoryIds = Set.from(_selectedCategoryIds)..remove(categoryId);
    } else {
      _selectedCategoryIds = Set.from(_selectedCategoryIds)..add(categoryId);
    }
    _emitCombined();
  }

  void toggleWarehouseFilter(String warehouseId) {
    if (_selectedWarehouseIds.contains(warehouseId)) {
      _selectedWarehouseIds = Set.from(_selectedWarehouseIds)
        ..remove(warehouseId);
    } else {
      _selectedWarehouseIds = Set.from(_selectedWarehouseIds)..add(warehouseId);
    }
    _emitCombined();
  }

  void toggleSectionFilter(String sectionId) {
    if (_selectedSectionIds.contains(sectionId)) {
      _selectedSectionIds = Set.from(_selectedSectionIds)..remove(sectionId);
    } else {
      _selectedSectionIds = Set.from(_selectedSectionIds)..add(sectionId);
    }
    _emitCombined();
  }

  void setCategoryFilter(Set<String> ids) {
    _selectedCategoryIds = ids;
    _emitCombined();
  }

  void setWarehouseFilter(Set<String> ids) {
    _selectedWarehouseIds = ids;
    _emitCombined();
  }

  void setSectionFilter(Set<String> ids) {
    _selectedSectionIds = ids;
    _emitCombined();
  }

  void setLabelingStatusFilter(Set<String> status) {
    _selectedLabelingStatus = status;
    _emitCombined();
  }

  void resetFilters() {
    _selectedCategoryIds = {};
    _selectedWarehouseIds = {};
    _selectedSectionIds = {};
    _selectedLabelingStatus = {};
    _searchQuery = '';
    _emitCombined();
  }

  Future<void> refreshFromLocal() async {
    _emitCombined();
  }

  @override
  Future<void> close() {
    _categorySub?.cancel();
    _companyItemSub?.cancel();
    return super.close();
  }
}
