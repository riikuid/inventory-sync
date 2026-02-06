// lib/features/inventory/presentation/bloc/variant_detail/variant_detail_cubit.dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_sync_apps/core/db/daos/unit_dao.dart';
import 'package:inventory_sync_apps/features/labeling/data/labeling_repository.dart';

import '../../../../core/db/model/variant_detail_row.dart';

part 'unit_detail_state.dart';

class UnitDetailCubit extends Cubit<UnitDetailState> {
  final LabelingRepository labelingRepo;

  StreamSubscription<UnitWithRelations?>? _sub;

  UnitDetailCubit({required this.labelingRepo}) : super(UnitDetailInitial());

  /// Start watching variant detail stream
  void watchDetail(String unitId) {
    emit(UnitDetailLoading());
    _sub?.cancel();
    _sub = labelingRepo
        .watchUnitDetail(unitId)
        .listen(
          (row) {
            if (row == null) {
              emit(const UnitDetailError('Unit not found'));
            } else {
              emit(UnitDetailLoaded(detail: row, isBusy: false));
            }
          },
          onError: (e) {
            emit(UnitDetailError(e.toString()));
          },
        );
  }

  Future<void> refresh(String unitId) async {
    emit(UnitDetailLoading());
    try {
      final row = await labelingRepo.watchUnitDetail(unitId).first;
      if (row == null) {
        emit(const UnitDetailError('Unit not found'));
      } else {
        emit(UnitDetailLoaded(detail: row, isBusy: false));
      }
    } catch (e) {
      emit(UnitDetailError(e.toString()));
    }
  }

  void setBusy(bool busy) {
    final s = state;
    if (s is UnitDetailLoaded) {
      emit(s.copyWith(isBusy: busy));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
