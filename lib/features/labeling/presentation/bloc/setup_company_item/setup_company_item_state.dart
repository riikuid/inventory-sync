// lib/features/labeling/presentation/cubit/setup_company_item_cubit.dart
part of 'setup_company_item_cubit.dart';

abstract class SetupCompanyItemState extends Equatable {
  const SetupCompanyItemState();

  @override
  List<Object?> get props => [];
}

class SetupCompanyItemInitial extends SetupCompanyItemState {}

class SetupCompanyItemLoading extends SetupCompanyItemState {}

class SetupCompanyItemSuccess extends SetupCompanyItemState {}

class SetupCompanyItemError extends SetupCompanyItemState {
  final String message;
  const SetupCompanyItemError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State utama yang dipakai UI.
/// Di sini kita simpan semua field + flag [isSaving].
class SetupCompanyItemLoaded extends SetupCompanyItemState {
  final String companyItemId;
  final String productName;
  final String companyCode;

  final bool? isSet;
  final bool? hasComponents;

  final String? brandId;
  final String? brandName; // ⬅️ NEW
  final String variantName;
  final String? defaultLocation;
  final String? specJson;

  final List<String> photoLocalPaths;
  final List<ComponentInput> newComponents;
  final List<String> selectedExistingComponentIds;

  final List<BrandOption> brands; // ⬅️ NEW

  final bool isSaving;

  const SetupCompanyItemLoaded({
    required this.companyItemId,
    required this.productName,
    required this.companyCode,
    required this.isSet,
    required this.hasComponents,
    required this.brandId,
    required this.brandName, // ⬅️ NEW
    required this.variantName,
    required this.defaultLocation,
    required this.specJson,
    required this.photoLocalPaths,
    required this.newComponents,
    required this.selectedExistingComponentIds,
    required this.brands, // ⬅️ NEW
    this.isSaving = false,
  });

  SetupCompanyItemLoaded copyWith({
    bool? isSet,
    bool? hasComponents,
    String? brandId,
    String? brandName,
    String? variantName,
    String? defaultLocation,
    String? specJson,
    List<String>? photoLocalPaths,
    List<ComponentInput>? newComponents,
    List<String>? selectedExistingComponentIds,
    List<BrandOption>? brands,
    bool? isSaving,
  }) {
    return SetupCompanyItemLoaded(
      companyItemId: companyItemId,
      productName: productName,
      companyCode: companyCode,
      isSet: isSet ?? this.isSet,
      hasComponents: hasComponents ?? this.hasComponents,
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      variantName: variantName ?? this.variantName,
      defaultLocation: defaultLocation ?? this.defaultLocation,
      specJson: specJson ?? this.specJson,
      photoLocalPaths: photoLocalPaths ?? this.photoLocalPaths,
      newComponents: newComponents ?? this.newComponents,
      selectedExistingComponentIds:
          selectedExistingComponentIds ?? this.selectedExistingComponentIds,
      brands: brands ?? this.brands,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [
    companyItemId,
    productName,
    companyCode,
    isSet,
    hasComponents,
    brandId,
    brandName,
    variantName,
    defaultLocation,
    specJson,
    photoLocalPaths,
    newComponents,
    selectedExistingComponentIds,
    brands,
    isSaving,
  ];
}
