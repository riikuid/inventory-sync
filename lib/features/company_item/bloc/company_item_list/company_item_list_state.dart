part of 'company_item_list_cubit.dart';

@immutable
sealed class CompanyItemListState {}

final class CompanyItemListLoading extends CompanyItemListState {}

final class CompanyItemListLoaded extends CompanyItemListState {
  final List<CategorySummary> categories;
  final List<CompanyItemListRow> companyItems;
  final List<Warehouse> warehouses;

  // Active Filters
  final Set<String> selectedCategoryIds;
  final Set<String> selectedWarehouseIds;
  final Set<String> selectedSectionIds;
  final String searchQuery;

  CompanyItemListLoaded({
    required this.categories,
    required this.companyItems,
    this.warehouses = const [],
    this.selectedCategoryIds = const {},
    this.selectedWarehouseIds = const {},
    this.selectedSectionIds = const {},
    this.searchQuery = '',
  });

  CompanyItemListLoaded copyWith({
    List<CategorySummary>? categories,
    List<CompanyItemListRow>? companyItems,
    List<Warehouse>? warehouses,
    Set<String>? selectedCategoryIds,
    Set<String>? selectedWarehouseIds,
    Set<String>? selectedSectionIds,
    String? searchQuery,
    bool clearCategoryIds = false,
    bool clearWarehouseIds = false,
    bool clearSectionIds = false,
  }) {
    return CompanyItemListLoaded(
      categories: categories ?? this.categories,
      companyItems: companyItems ?? this.companyItems,
      warehouses: warehouses ?? this.warehouses,
      selectedCategoryIds: clearCategoryIds
          ? const {}
          : (selectedCategoryIds ?? this.selectedCategoryIds),
      selectedWarehouseIds: clearWarehouseIds
          ? const {}
          : (selectedWarehouseIds ?? this.selectedWarehouseIds),
      selectedSectionIds: clearSectionIds
          ? const {}
          : (selectedSectionIds ?? this.selectedSectionIds),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  int get activeFilterCount {
    return selectedCategoryIds.length +
        selectedWarehouseIds.length +
        selectedSectionIds.length;
  }
}

final class CompanyItemListError extends CompanyItemListState {
  final String message;
  CompanyItemListError(this.message);
}
