// // lib/features/labeling/presentation/cubit/setup_company_item_cubit.dart
// part of 'setup_company_item_cubit.dart';

// abstract class SetupCompanyItemState extends Equatable {
//   const SetupCompanyItemState();

//   @override
//   List<Object?> get props => [];
// }

// class SetupCompanyItemInitial extends SetupCompanyItemState {}

// class SetupCompanyItemLoading extends SetupCompanyItemState {}

// class SetupCompanyItemSuccess extends SetupCompanyItemState {}

// class SetupCompanyItemError extends SetupCompanyItemState {
//   final String message;
//   const SetupCompanyItemError(this.message);

//   @override
//   List<Object?> get props => [message];
// }

// /// State utama yang dipakai UI.
// /// Di sini kita simpan semua field + flag [isSaving].
// class SetupCompanyItemLoaded extends SetupCompanyItemState {
//   final String companyItemId;
//   final String productName;
//   final String companyCode;

//   final String? brandId;
//   final String? brandName;
//   final String variantName;
//   final String? defaultRackId;
//   final String? defaultRackName;
//   final String? specification;

//   final List<String> photoLocalPaths;
//   final List<ComponentInput> newComponents;
//   final List<String> selectedExistingComponentIds;

//   final List<BrandOption> brands;

//   /// NEW: brand apa saja yang sudah punya variant
//   final List<String> usedBrandIds;

//   final bool hasVariants;
//   final bool isSaving;

//   const SetupCompanyItemLoaded({
//     required this.companyItemId,
//     required this.productName,
//     required this.companyCode,
//     required this.brandId,
//     required this.brandName,
//     required this.variantName,
//     required this.defaultRackId,
//     required this.defaultRackName,
//     required this.specification,
//     required this.photoLocalPaths,
//     required this.newComponents,
//     required this.selectedExistingComponentIds,
//     required this.brands,
//     required this.hasVariants,
//     required this.usedBrandIds, // NEW
//     this.isSaving = false,
//   });

//   SetupCompanyItemLoaded copyWith({
//     String? brandId,
//     String? brandName,
//     String? variantName,
//     String? defaultRackId,
//     String? defaultRackName,
//     String? specification,
//     List<String>? photoLocalPaths,
//     List<ComponentInput>? newComponents,
//     List<String>? selectedExistingComponentIds,
//     List<BrandOption>? brands,
//     bool? hasVariants,
//     List<String>? usedBrandIds,
//     bool? isSaving,
//   }) {
//     return SetupCompanyItemLoaded(
//       companyItemId: companyItemId,
//       productName: productName,
//       companyCode: companyCode,
//       brandId: brandId ?? this.brandId,
//       brandName: brandName ?? this.brandName,
//       variantName: variantName ?? this.variantName,
//       defaultRackId: defaultRackId ?? this.defaultRackId,
//       defaultRackName: defaultRackName ?? this.defaultRackName,
//       specification: specification ?? this.specification,
//       photoLocalPaths: photoLocalPaths ?? this.photoLocalPaths,
//       newComponents: newComponents ?? this.newComponents,
//       selectedExistingComponentIds:
//           selectedExistingComponentIds ?? this.selectedExistingComponentIds,
//       brands: brands ?? this.brands,
//       usedBrandIds: usedBrandIds ?? this.usedBrandIds,
//       hasVariants: hasVariants ?? this.hasVariants,
//       isSaving: isSaving ?? this.isSaving,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     companyItemId,
//     productName,
//     companyCode,
//     brandId,
//     brandName,
//     variantName,
//     defaultRackId,
//     defaultRackName,
//     specification,
//     photoLocalPaths,
//     newComponents,
//     selectedExistingComponentIds,
//     brands,
//     usedBrandIds,
//     hasVariants,
//     isSaving,
//   ];
// }
