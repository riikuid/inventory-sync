// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../inventory/data/inventory_repository.dart';
// import '../../../data/labeling_repository.dart';

// part 'setup_company_item_state.dart';

// // misal di setup_company_item_cubit.dart, di atas class Cubit
// class BrandOption {
//   final String id;
//   final String name;

//   BrandOption({required this.id, required this.name});
// }

// class SetupCompanyItemCubit extends Cubit<SetupCompanyItemState> {
//   final InventoryRepository inventoryRepo;
//   final LabelingRepository labelingRepo;

//   SetupCompanyItemCubit({
//     required this.inventoryRepo,
//     required this.labelingRepo,
//   }) : super(SetupCompanyItemInitial());

//   Future<void> loadInitial(String companyItemId) async {
//     emit(SetupCompanyItemLoading());
//     try {
//       final detail = await inventoryRepo.getCompanyItemDetail(companyItemId);
//       if (detail == null) {
//         emit(const SetupCompanyItemError('Item not found'));
//         return;
//       }

//       // ambil brand dari DB
//       final brandRows = await inventoryRepo.getAllBrands();
//       final brands = brandRows
//           .map((b) => BrandOption(id: b.id, name: b.name))
//           .toList();

//       // aturan: tipe item hanya bisa diedit jika BELUM ada variant
//       final hasVariants = detail.variants.isNotEmpty;

//       // brand yang sudah dipakai variant lain
//       final usedBrandIds = detail.variants
//           .map((v) => v.brandId)
//           .whereType<String>()
//           .toSet()
//           .toList();

//       emit(
//         SetupCompanyItemLoaded(
//           companyItemId: companyItemId,
//           productName: detail.productName,
//           companyCode: detail.companyCode,
//           // kalau sudah ada variant, pakai nilai isSet/hasComponents dari detail,
//           // kalau belum, biarkan null supaya user pilih pertama kali
//           brandId: null,
//           brandName: null,
//           variantName: '${detail.companyCode} ${detail.productName}',
//           defaultRackId: null,
//           defaultRackName: null,
//           specification: null,
//           photoLocalPaths: const [],
//           newComponents: const [],
//           selectedExistingComponentIds: const [],
//           brands: brands,
//           usedBrandIds: usedBrandIds,
//           hasVariants: hasVariants,
//           isSaving: false,
//         ),
//       );
//     } catch (e) {
//       emit(SetupCompanyItemError(e.toString()));
//     }
//   }

//   void updateBrand(String? brandId) {
//     final s = state;
//     if (s is SetupCompanyItemLoaded) {
//       emit(s.copyWith(brandId: brandId));
//     }
//   }

//   void updateVariantName(String value) {
//     final s = state;
//     if (s is SetupCompanyItemLoaded) {
//       emit(s.copyWith(variantName: value));
//     }
//   }

//   void updateLocation(String? value) {
//     final s = state;
//     if (s is SetupCompanyItemLoaded) {
//       emit(s.copyWith(brandId: value));
//     }
//   }

//   void updateSpecification(String? value) {
//     final s = state;
//     if (s is SetupCompanyItemLoaded) {
//       emit(s.copyWith(specification: value));
//     }
//   }

//   void addPhoto(String localPath) {
//     final s = state;
//     if (s is SetupCompanyItemLoaded) {
//       final updated = List<String>.from(s.photoLocalPaths)..add(localPath);
//       emit(s.copyWith(photoLocalPaths: updated));
//     }
//   }

//   void removePhotoAt(int index) {
//     final s = state;
//     if (s is SetupCompanyItemLoaded) {
//       final updated = List<String>.from(s.photoLocalPaths)..removeAt(index);
//       emit(s.copyWith(photoLocalPaths: updated));
//     }
//   }

//   void addNewComponent(ComponentInput input) {
//     final s = state;
//     if (s is SetupCompanyItemLoaded) {
//       final updated = List<ComponentInput>.from(s.newComponents)..add(input);
//       emit(s.copyWith(newComponents: updated));
//     }
//   }

//   void toggleExistingComponent(String id) {
//     final s = state;
//     if (s is SetupCompanyItemLoaded) {
//       final set = s.selectedExistingComponentIds.toSet();
//       if (set.contains(id)) {
//         set.remove(id);
//       } else {
//         set.add(id);
//       }
//       emit(s.copyWith(selectedExistingComponentIds: set.toList()));
//     }
//   }

//   void onBrandSelected(BrandOption? brand) {
//     final s = state;
//     if (s is! SetupCompanyItemLoaded || brand == null) return;

//     // Jangan boleh pilih brand yang sudah dipakai
//     if (s.usedBrandIds.contains(brand.id)) {
//       emit(
//         const SetupCompanyItemError(
//           'Brand ini sudah dipakai untuk variant lain pada kode ini.',
//         ),
//       );
//       return;
//     }

//     final oldBrandName = s.brandName;
//     final autoBefore =
//         (s.companyCode + ' ' + s.productName + ' ' + (oldBrandName ?? ''))
//             .trim();
//     final autoAfter = (s.companyCode + ' ' + s.productName + ' ' + brand.name)
//         .trim();

//     final current = s.variantName;

//     final shouldOverwrite = current.isEmpty || current == autoBefore;

//     emit(
//       s.copyWith(
//         brandId: brand.id,
//         brandName: brand.name,
//         variantName: shouldOverwrite ? autoAfter : current,
//       ),
//     );
//   }

//   Future<void> submit({
//     required String userId,
//     required String productId,
//   }) async {
//     final s = state;
//     if (s is! SetupCompanyItemLoaded) return;

//     // Validasi ringan
//     if (s.photoLocalPaths.length < 3) {
//       emit(const SetupCompanyItemError('Minimal 3 foto'));
//       return;
//     }

//     // Validasi Brand
//     if (s.brandId == null) {
//       emit(const SetupCompanyItemError('Pilih brand terlebih dahulu'));
//       return;
//     }
//     if (s.usedBrandIds.contains(s.brandId)) {
//       emit(
//         const SetupCompanyItemError(
//           'Sudah ada variant dengan brand ini untuk item ini.',
//         ),
//       );
//       return;
//     }

//     // set isSaving = true
//     emit(s.copyWith(isSaving: true));

//     try {
//       await labelingRepo.setupCompanyItem(
//         companyItemId: s.companyItemId,

//         isSet: s.isSet!,
//         hasComponents: s.hasComponents!,
//         brandId: s.brandId,
//         variantName: s.variantName,
//         defaultLocation: s.defaultLocation,
//         specJson: s.specJson,
//         photoLocalPaths: s.photoLocalPaths,
//         userId: userId,
//       );

//       emit(SetupCompanyItemSuccess());
//     } catch (e) {
//       // balik lagi ke Loaded dengan isSaving false biar UI tetap punya form
//       emit(s.copyWith(isSaving: false));
//       emit(SetupCompanyItemError(e.toString()));
//     }
//   }
// }
