// lib/features/inventory/presentation/bloc/variant_detail/variant_detail_cubit.dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/db/model/variant_detail_row.dart';
import '../../../inventory/data/inventory_repository.dart';
import '../../../labeling/data/labeling_repository.dart';

part 'variant_detail_state.dart';

class VariantDetailCubit extends Cubit<VariantDetailState> {
  final InventoryRepository repo;
  final LabelingRepository labelingRepo;

  StreamSubscription<VariantDetailRow?>? _sub;

  VariantDetailCubit({required this.repo, required this.labelingRepo})
    : super(VariantDetailInitial());

  /// Start watching variant detail stream
  void watchDetail(String variantId) {
    emit(VariantDetailLoading());
    _sub?.cancel();
    _sub = repo
        .watchVariantDetail(variantId)
        .listen(
          (row) {
            if (row == null) {
              emit(const VariantDetailError('Variant not found'));
            } else {
              emit(VariantDetailLoaded(detail: row, isBusy: false));
            }
          },
          onError: (e) {
            emit(VariantDetailError(e.toString()));
          },
        );
  }

  Future<void> refresh(String variantId) async {
    emit(VariantDetailLoading());
    try {
      final row = await repo.watchVariantDetail(variantId).first;
      if (row == null) {
        emit(const VariantDetailError('Variant not found'));
      } else {
        emit(VariantDetailLoaded(detail: row, isBusy: false));
      }
    } catch (e) {
      emit(VariantDetailError(e.toString()));
    }
  }

  void setBusy(bool busy) {
    final s = state;
    if (s is VariantDetailLoaded) {
      emit(s.copyWith(isBusy: busy));
    }
  }

  /// Add component (existing) to variant (variant_components)
  Future<void> addComponentFromExisting({
    required String variantId,
    required String componentId,
  }) async {
    try {
      setBusy(true);
      await repo.attachComponentToVariant(
        variantId: variantId,
        componentId: componentId,
      );
    } catch (e) {
      final s = state;
      if (s is VariantDetailLoaded) {
        emit(s.copyWith(errorMessage: e.toString()));
        emit(s.copyWith(errorMessage: null)); // clear quickly
      } else {
        emit(VariantDetailError(e.toString()));
      }
    } finally {
      setBusy(false);
    }
  }

  /// Remove relation component <-> variant
  Future<void> detachComponent({
    required String variantId,
    required String componentId,
  }) async {
    try {
      setBusy(true);
      await repo.detachComponentFromVariant(
        variantId: variantId,
        componentId: componentId,
      );
    } catch (e) {
      final s = state;
      if (s is VariantDetailLoaded) {
        emit(s.copyWith(errorMessage: e.toString()));
        emit(s.copyWith(errorMessage: null));
      } else {
        emit(VariantDetailError(e.toString()));
      }
    } finally {
      setBusy(false);
    }
  }

  /// Update quantity komponen dalam variant
  Future<void> updateComponentQuantity({
    required String variantId,
    required String componentId,
    required int newQuantity,
  }) async {
    try {
      setBusy(true);
      await repo.updateVariantComponentQuantity(
        variantId: variantId,
        componentId: componentId,
        quantity: newQuantity,
      );
      // State akan auto-refresh karena watchDetail() masih aktif
    } catch (e) {
      final s = state;
      if (s is VariantDetailLoaded) {
        emit(s.copyWith(errorMessage: e.toString()));
        emit(s.copyWith(errorMessage: null)); // clear quickly
      } else {
        emit(VariantDetailError(e.toString()));
      }
    } finally {
      setBusy(false);
    }
  }

  /// Delete component (destructive) - be careful
  Future<void> deleteComponent({required String componentId}) async {
    try {
      setBusy(true);
      await repo.deleteComponent(componentId);
    } catch (e) {
      final s = state;
      if (s is VariantDetailLoaded) {
        emit(s.copyWith(errorMessage: e.toString()));
        emit(s.copyWith(errorMessage: null));
      } else {
        emit(VariantDetailError(e.toString()));
      }
    } finally {
      setBusy(false);
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
