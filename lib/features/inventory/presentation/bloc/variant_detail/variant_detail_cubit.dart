// lib/features/inventory/presentation/bloc/variant_detail/variant_detail_cubit.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/inventory_repository.dart';
import 'variant_detail_state.dart';

class VariantDetailCubit extends Cubit<VariantDetailState> {
  final InventoryRepository repo;
  StreamSubscription? _sub;

  VariantDetailCubit(this.repo) : super(VariantDetailInitial());

  void watchDetail(String variantId) {
    emit(VariantDetailLoading());

    _sub?.cancel();
    _sub = repo
        .watchVariantDetail(variantId)
        .listen(
          (detail) {
            if (detail == null) {
              emit(VariantDetailError('Variant tidak ditemukan'));
            } else {
              emit(VariantDetailLoaded(detail: detail));
            }
          },
          onError: (e) {
            emit(VariantDetailError(e.toString()));
          },
        );
  }

  Future<void> addComponentFromExisting({
    required String variantId,
    required String componentId,
  }) async {
    final s = state;
    if (s is! VariantDetailLoaded) return;

    // CEK DUPLIKAT
    final alreadyLinked = s.detail.components.any(
      (c) => c.componentId == componentId,
    );
    if (alreadyLinked) {
      // lempar error friendly
      emit(s.copyWith(errorMessage: 'Komponen ini sudah terdaftar di set.'));
      return;
    }

    emit(s.copyWith(isBusy: true, errorMessage: null));
    try {
      await repo.attachComponentToVariant(
        variantId: variantId,
        componentId: componentId,
      );
      emit(s.copyWith(isBusy: false));
    } catch (e) {
      emit(s.copyWith(isBusy: false, errorMessage: e.toString()));
    }
  }

  Future<void> detachComponent({
    required String variantId,
    required String componentId,
  }) async {
    final s = state;
    if (s is! VariantDetailLoaded) return;
    emit(s.copyWith(isBusy: true, errorMessage: null));
    try {
      await repo.detachComponentFromVariant(
        variantId: variantId,
        componentId: componentId,
      );
      emit(s.copyWith(isBusy: false));
    } catch (e) {
      emit(s.copyWith(isBusy: false, errorMessage: e.toString()));
    }
  }

  Future<void> deleteComponent({required String componentId}) async {
    final s = state;
    if (s is! VariantDetailLoaded) return;
    emit(s.copyWith(isBusy: true, errorMessage: null));
    try {
      await repo.deleteComponent(componentId);
      emit(s.copyWith(isBusy: false));
    } catch (e) {
      emit(s.copyWith(isBusy: false, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
