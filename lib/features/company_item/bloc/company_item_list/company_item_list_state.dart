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
  final Set<String> selectedLabelingStatus; // New field
  final String searchQuery;

  CompanyItemListLoaded({
    required this.categories,
    required this.companyItems,
    this.warehouses = const [],
    this.selectedCategoryIds = const {},
    this.selectedWarehouseIds = const {},
    this.selectedSectionIds = const {},
    this.selectedLabelingStatus = const {}, // Initialize
    this.searchQuery = '',
  });

  CompanyItemListLoaded copyWith({
    List<CategorySummary>? categories,
    List<CompanyItemListRow>? companyItems,
    List<Warehouse>? warehouses,
    Set<String>? selectedCategoryIds,
    Set<String>? selectedWarehouseIds,
    Set<String>? selectedSectionIds,
    Set<String>? selectedLabelingStatus, // New parameter
    String? searchQuery,
    bool clearCategoryIds = false,
    bool clearWarehouseIds = false,
    bool clearSectionIds = false,
    bool clearLabelingStatus = false, // New parameter
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
      selectedLabelingStatus: clearLabelingStatus
          ? const {}
          : (selectedLabelingStatus ?? this.selectedLabelingStatus),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  int get activeFilterCount {
    return selectedCategoryIds.length +
        selectedWarehouseIds.length +
        selectedSectionIds.length +
        selectedLabelingStatus.length;
  }
}

final class CompanyItemListError extends CompanyItemListState {
  final String message;
  CompanyItemListError(this.message);
}
