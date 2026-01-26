import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/db/app_database.dart';
import '../../../../core/db/model/photo_row.dart';
import '../../../labeling/data/labeling_repository.dart';

part 'edit_variant_state.dart';

class EditVariantCubit extends Cubit<EditVariantState> {
  final LabelingRepository labelingRepository;
  final String variantId;
  final int userId;

  EditVariantCubit({
    required this.labelingRepository,
    required this.variantId,
    required this.userId,
  }) : super(EditVariantState.initial());

  // Load variant data untuk di-edit
  Future<void> loadVariant() async {
    emit(state.copyWith(status: EditVariantStatus.loading));

    try {
      final variant = await labelingRepository.getVariantById(variantId);
      if (variant == null) {
        emit(
          state.copyWith(
            status: EditVariantStatus.failure,
            errorMessage: 'Variant tidak ditemukan',
          ),
        );
        return;
      }

      final photos = await labelingRepository.getVariantPhotos(variantId);
      final uoms = await labelingRepository.getUoms();

      // Ambil nama brand jika ada brandId
      String? brandName = 'Tanpa Brand';
      if (variant.brandId != null) {
        final brand = await labelingRepository.getBrandById(variant.brandId!);
        brandName = brand?.name ?? 'Tanpa Brand';
      }

      // Ambil informasi rack lengkap jika ada rackId
      String? rackName;
      if (variant.rackId != null) {
        final rackDetails = await labelingRepository.getRackById(
          variant.rackId!,
        );
        if (rackDetails != null) {
          // Jika getRackById return Map dengan displayName
          // if (rackDetails is Map<String, dynamic>) {
          //   rackName = rackDetails['displayName'] as String?;
          // } else {
          // Jika hanya return Rack object
          rackName = rackDetails.name;
          // }
        }
      }

      emit(
        state.copyWith(
          status: EditVariantStatus.loaded,
          rackId: variant.rackId,
          rackName: rackName,
          brandId: variant.brandId,
          brandName: brandName,
          name: variant.name,
          uom: variant.uom,
          uomId: variant.uomId,
          uomList: uoms,
          specification: variant.specification,
          manufCode: variant.manufCode,
          photos: photos.map((p) {
            return PhotoRow(
              id: p.id,
              localPath: p.localPath,
              remoteUrl: p.remoteUrl,
            );
          }).toList(),
          autoBase: variant.name, // Simpan nama asli sebagai base
          userEdited: true, // Anggap sudah diedit karena ini data existing
        ),
      );
    } catch (e) {
      log('Error loading variant: $e');
      emit(
        state.copyWith(
          status: EditVariantStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Helper compose auto name (sama seperti create)
  String _composeAutoName(String autoBase, String? brandName) {
    final base = autoBase.trim();
    if (base.isEmpty) return brandName?.trim() ?? '';
    if (brandName == null ||
        brandName.trim().isEmpty ||
        brandName == 'Tanpa Brand') {
      return base;
    }
    return '$base ${brandName.trim()}';
  }

  // Set rack
  void setRack(String? rackId, String? rackName) {
    emit(state.copyWith(rackId: rackId, rackName: rackName));
  }

  // Set brand dengan auto-compose name jika belum user-edited
  void onBrandSelected(String? brandId, String? brandName) {
    final s = state;
    if (!s.userEdited) {
      final newName = _composeAutoName(s.autoBase, brandName);
      emit(
        s.copyWith(
          brandId: brandId,
          brandName: brandName ?? 'Tanpa Brand',
          name: newName,
          userEdited: false,
        ),
      );
    } else {
      emit(s.copyWith(brandId: brandId, brandName: brandName ?? 'Tanpa Brand'));
    }
  }

  // Set name
  void setName(String name) {
    final s = state;
    final autoComposed = _composeAutoName(s.autoBase, s.brandName);
    final isAuto = name.trim() == autoComposed.trim();
    emit(s.copyWith(name: name, userEdited: !isAuto));
  }

  // Set UOM
  void setUom(String uomId, String uomName) {
    emit(state.copyWith(uomId: uomId, uom: uomName));
  }

  // Set specification
  void setSpecification(String? spec) {
    emit(state.copyWith(specification: spec));
  }

  // Set manufCode
  void setManufCode(String? manufCode) {
    emit(state.copyWith(manufCode: manufCode));
  }

  // Validasi sebelum submit
  bool get canSubmit =>
      state.name.trim().isNotEmpty &&
      state.uom != null &&
      state.uomId != null &&
      state.photos.isNotEmpty;

  // Submit update
  Future<void> submit() async {
    if (!canSubmit) return;

    emit(state.copyWith(status: EditVariantStatus.loading));

    try {
      await labelingRepository.updateVariant(
        variantId: variantId,
        brandId: state.brandId,
        variantName: state.name,
        uom: state.uom!,
        uomId: state.uomId!,
        rackId: state.rackId,
        specification: state.specification,
        manufCode: state.manufCode,
        userId: userId,
      );

      emit(state.copyWith(status: EditVariantStatus.success));
    } catch (e) {
      log('Error updating variant: $e');
      emit(
        state.copyWith(
          status: EditVariantStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
