import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../labeling/data/labeling_repository.dart';

part 'create_variant_state.dart';

class CreateVariantCubit extends Cubit<CreateVariantState> {
  final LabelingRepository labelingRepository;
  final String companyItemId;
  final String userId;
  final String? defaultRackId; // dari company item detail

  CreateVariantCubit({
    required this.labelingRepository,
    required this.companyItemId,
    required this.userId,
    this.defaultRackId,
  }) : super(CreateVariantState.initial()) {
    // prefill rack kalau tersedia
    if (defaultRackId != null) {
      emit(state.copyWith(rackId: defaultRackId));
    }
  }

  void setRack(String rackId, String rackName) {
    emit(state.copyWith(rackId: rackId, rackName: rackName));
  }

  void setBrand(String? brandId, String? brandName) {
    emit(state.copyWith(brandId: brandId, brandName: brandName));
  }

  void setName(String name) => emit(state.copyWith(name: name));

  void setUom(String uom) => emit(state.copyWith(uom: uom));

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
      state.rackId != null &&
      state.name.trim().isNotEmpty &&
      state.uom != null &&
      state.photos.length >= 3;

  Future<void> submit() async {
    if (!canSubmit) return;

    emit(state.copyWith(status: CreateVariantStatus.loading));

    try {
      await labelingRepository.createVariant(
        companyItemId: companyItemId,
        brandId: state.brandId,
        variantName: state.name,
        uom: state.uom!,
        rackId: state.rackId!,
        specification: state.specification,
        manufCode: state.manufCode,
        photoLocalPaths: state.photos,
        userId: userId,
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
