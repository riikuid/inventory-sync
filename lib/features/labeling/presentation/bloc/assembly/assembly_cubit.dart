// lib/features/labeling/presentation/bloc/assembly/assembly_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/labeling_repository.dart';
import 'assembly_state.dart';

class AssemblyCubit extends Cubit<AssemblyState> {
  final LabelingRepository labelingRepository;
  final String userId;

  AssemblyCubit({
    required this.labelingRepository,
    required String variantId,
    required String variantName,
    required this.userId,
  }) : super(AssemblyReady(variantId: variantId, variantName: variantName));

  Future<void> scanComponentA(String qrValue) async {
    final s = state;
    if (s is! AssemblyReady) return;

    try {
      final result = await labelingRepository.scanUnitByQr(qrValue);
      if (result == null) {
        emit(s.copyWith(errorMessage: 'QR tidak ditemukan'));
        return;
      }
      if (result.status != 'ACTIVE') {
        emit(
          s.copyWith(
            errorMessage:
                'QR ini tidak dapat dipakai (status: ${result.status})',
          ),
        );
        return;
      }
      if (result.componentId == null) {
        emit(s.copyWith(errorMessage: 'QR ini bukan unit komponen'));
        return;
      }

      emit(s.copyWith(componentA: result, errorMessage: null));
    } catch (e) {
      emit(AssemblyError(e.toString()));
    }
  }

  Future<void> scanComponentB(String qrValue) async {
    final s = state;
    if (s is! AssemblyReady) return;

    try {
      final result = await labelingRepository.scanUnitByQr(qrValue);
      if (result == null) {
        emit(s.copyWith(errorMessage: 'QR tidak ditemukan'));
        return;
      }
      if (result.status != 'ACTIVE') {
        emit(
          s.copyWith(
            errorMessage:
                'QR ini tidak dapat dipakai (status: ${result.status})',
          ),
        );
        return;
      }
      if (result.componentId == null) {
        emit(s.copyWith(errorMessage: 'QR ini bukan unit komponen'));
        return;
      }

      // optional: cegah scan QR yang sama untuk A dan B
      if (s.componentA != null && s.componentA!.unitId == result.unitId) {
        emit(s.copyWith(errorMessage: 'Tidak boleh pakai unit yang sama'));
        return;
      }

      emit(s.copyWith(componentB: result, errorMessage: null));
    } catch (e) {
      emit(AssemblyError(e.toString()));
    }
  }

  Future<void> assemble({String? location}) async {
    final s = state;
    if (s is! AssemblyReady) return;
    if (!s.canAssemble) return;

    final compA = s.componentA!;
    final compB = s.componentB!;

    emit(s.copyWith(isSaving: true, errorMessage: null));

    try {
      final result = await labelingRepository.assembleComponents(
        variantId: s.variantId,
        componentUnitIds: [compA.unitId, compB.unitId],
        userId: userId,
        location: location,
      );

      emit(
        s.copyWith(isSaving: false, assemblyResult: result, errorMessage: null),
      );
    } catch (e) {
      emit(s.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }
}
