import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../inventory/data/inventory_repository.dart';

part 'company_item_detail_state.dart';

/// Cubit yang robust: ketika ada update pada variants, kita reload
/// keseluruhan CompanyItemDetail snapshot dari repository supaya UI selalu sinkron.
class CompanyItemDetailCubit extends Cubit<CompanyItemDetailState> {
  final InventoryRepository repo;
  StreamSubscription? _watchSub;

  CompanyItemDetailCubit(this.repo) : super(CompanyItemDetailInitial());

  /// watchDetail: emit initial snapshot, lalu subscribe ke perubahan varian.
  Future<void> watchDetail(String companyItemId) async {
    emit(CompanyItemDetailLoading());
    _watchSub?.cancel();

    try {
      // 1) ambil snapshot awal dan emit
      final snapshot = await repo.getCompanyItemDetail(companyItemId);
      if (snapshot == null) {
        emit(const CompanyItemDetailError('Item tidak ditemukan'));
        return;
      }
      emit(CompanyItemDetailLoaded(snapshot));

      // 2) subscribe ke perubahan varian untuk kode ini
      //    ketika ada perubahan, ambil ulang snapshot lengkap
      _watchSub = repo
          .watchVariantsWithStockForItem(companyItemId)
          .listen(
            (event) async {
              try {
                final refreshed = await repo.getCompanyItemDetail(
                  companyItemId,
                );
                if (refreshed == null) {
                  emit(
                    const CompanyItemDetailError(
                      'Item tidak ditemukan (refresh)',
                    ),
                  );
                } else {
                  emit(CompanyItemDetailLoaded(refreshed));
                }
              } catch (e) {
                emit(CompanyItemDetailError(e.toString()));
              }
            },
            onError: (e) {
              emit(CompanyItemDetailError(e.toString()));
            },
          );
    } catch (e) {
      emit(CompanyItemDetailError(e.toString()));
    }
  }

  /// manual reload (dipakai RefreshIndicator)
  Future<void> loadDetail(String companyItemId) async {
    emit(CompanyItemDetailLoading());
    try {
      final detail = await repo.getCompanyItemDetail(companyItemId);
      if (detail == null) {
        emit(const CompanyItemDetailError('Item tidak ditemukan'));
      } else {
        emit(CompanyItemDetailLoaded(detail));
      }
    } catch (e) {
      emit(CompanyItemDetailError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _watchSub?.cancel();
    return super.close();
  }
}
