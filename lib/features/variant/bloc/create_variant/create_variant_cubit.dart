import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/db/app_database.dart';
import '../../../labeling/data/labeling_repository.dart';

part 'create_variant_state.dart';

class CreateVariantCubit extends Cubit<CreateVariantState> {
  final LabelingRepository labelingRepository;
  final String companyItemId;
  final int userId;
  final bool isSetUp;
  final String? defaultRackId;
  final String? defaultRackName;
  final String? purchasingUomId;

  CreateVariantCubit({
    required this.labelingRepository,
    required this.companyItemId,
    required this.userId,
    this.isSetUp = false,
    this.defaultRackId,
    this.defaultRackName,
    this.purchasingUomId,
  }) : super(CreateVariantState.initial()) {
    if (isSetUp == false && defaultRackId != null) {
      emit(state.copyWith(rackId: defaultRackId, rackName: defaultRackName));
    }
  }

  // helper compose
  String _composeAutoName(String autoBase, String? brandName) {
    final base = autoBase.trim();
    if (base.isEmpty) return brandName?.trim() ?? '';
    if (brandName == null ||
        brandName.trim().isEmpty ||
        brandName == 'Tanpa Brand') {
      return base;
    }
    return '$base-${brandName.trim()}';
  }

  // contoh method: inisialisasi create flow
  // panggil ini ketika open create variant screen
  Future<void> initFor({
    required String productName,
    String? defaultRackId,
    String? defaultRackName,
    String? purchasingUomId,
  }) async {
    final autoBase = productName;
    final uoms = await labelingRepository.getUoms();

    Uom? selectedUom;
    if (purchasingUomId != null) {
      try {
        selectedUom = uoms.firstWhere((e) => e.purchasingId == purchasingUomId);
      } catch (e) {
        log('e CreateVariantCubit.initFor: $e');
      }
    }
    // set initial state with autoBase and name=autoBase
    emit(
      CreateVariantState.initial(autoBase: autoBase).copyWith(
        rackId: defaultRackId,
        rackName: defaultRackName,
        uomList: uoms,
        name: productName,
        uomId: selectedUom?.id,
        uom: selectedUom?.name,

        // brand default "Tanpa Brand" already set in factory
      ),
    );
  }

  // user mengetik di textfield
  void updateName(String value) {
    final s = state;
    // if the typed value equals auto composed name, treat as not userEdited
    final autoComposed = _composeAutoName(s.autoBase, s.brandName);
    final isAuto = value.trim() == autoComposed.trim();
    emit(s.copyWith(name: value, userEdited: !isAuto));
  }

  // user memilih brand dari picker
  void onBrandSelected(String? brandId, String? brandName) {
    final s = state;
    // update brand fields
    if (!s.userEdited) {
      // override name only when user not manually edited
      final newName = _composeAutoName(s.autoBase, brandName);
      emit(
        s.copyWith(
          brandId: brandId,
          brandName: brandName ?? 'Tanpa Brand',
          name: newName,
          userEdited: false, // still system-controlled
        ),
      );
    } else {
      // user has custom name -> don't override name
      emit(s.copyWith(brandId: brandId, brandName: brandName ?? 'Tanpa Brand'));
    }
  }

  void setRack(String rackId, String rackName) {
    emit(state.copyWith(rackId: rackId, rackName: rackName));
  }

  void setBrand(String? brandId, String? brandName) {
    emit(state.copyWith(brandId: brandId, brandName: brandName));
  }

  void setName(String name) => emit(state.copyWith(name: name));

  void setUom(String uomId, String uomName) =>
      emit(state.copyWith(uomId: uomId, uom: uomName));

  void setSpecification(String? spec) =>
      emit(state.copyWith(specification: spec));

  void setManufCode(String? manufCode) =>
      emit(state.copyWith(manufCode: manufCode));

  Future<void> addPhoto(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;

    final updated = List<String>.from(state.photos)..add(picked.path);
    emit(state.copyWith(photos: updated));
  }

  void removePhoto(int index) {
    final updated = List<String>.from(state.photos)..removeAt(index);
    emit(state.copyWith(photos: updated));
  }

  bool get canSubmit =>
      // state.rackId != null &&
      state.name.trim().isNotEmpty &&
      state.uom != null &&
      state.uomId != null &&
      state.photos.isNotEmpty; // minimal 3

  Future<void> submit() async {
    if (!canSubmit) return;

    emit(state.copyWith(status: CreateVariantStatus.loading));

    try {
      await labelingRepository.createVariant(
        companyItemId: companyItemId,
        brandId: state.brandId,
        variantName: state.name,
        uom: state.uom!,
        uomId: state.uomId!,
        rackId: state.rackId,
        specification: state.specification,
        manufCode: state.manufCode,
        photoLocalPaths: state.photos,
        userId: userId,
        isSetUp: isSetUp,
      );

      emit(state.copyWith(status: CreateVariantStatus.success));
    } catch (e) {
      log('e CreateVariantCubit.submit: $e');
      emit(
        state.copyWith(
          status: CreateVariantStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
