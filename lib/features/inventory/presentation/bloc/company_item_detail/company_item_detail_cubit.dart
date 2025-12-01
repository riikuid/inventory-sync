import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/inventory_repository.dart';

part 'company_item_detail_state.dart';

class CompanyItemDetailCubit extends Cubit<CompanyItemDetailState> {
  final InventoryRepository repo;
  StreamSubscription? _variantSub;

  CompanyItemDetailCubit(this.repo) : super(CompanyItemDetailInitial());

  Future<void> watchDetail(String companyItemId) async {
    emit(CompanyItemDetailLoading());

    try {
      // 1) Ambil snapshot awal untuk header (company code, product name, dll)
      final baseDetail = await repo.getCompanyItemDetail(companyItemId);

      // Emit dulu dengan stok awal
      emit(CompanyItemDetailLoaded(baseDetail!));

      // 2) Subscribe ke perubahan stok varian
      _variantSub?.cancel();
      _variantSub = repo
          .watchVariantsWithStockForItem(companyItemId)
          .listen(
            (variants) {
              final current = state;
              if (current is CompanyItemDetailLoaded) {
                // Asumsikan CompanyItemDetail punya field variants
                final updated = current.detail.copyWith(
                  variants: variants.map((v) {
                    // mapping dari CompanyItemVariantRow ke model varian yang kamu pakai di UI
                    return current.detail.variants
                        .firstWhere(
                          (old) => old.variantId == v.variantId,
                          // orElse: () => /* bikin baru dari v */,
                        )
                        .copyWith(
                          stock: v.stock,
                          // kalau mau update brandName/defaultLocation juga bisa
                        );
                  }).toList(),
                );

                emit(CompanyItemDetailLoaded(updated));
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

  @override
  Future<void> close() {
    _variantSub?.cancel();
    return super.close();
  }

  Future<void> loadDetail(String companyItemId) async {
    emit(CompanyItemDetailLoading());
    try {
      final detail = await repo.getCompanyItemDetail(companyItemId);
      if (detail == null) {
        emit(const CompanyItemDetailError('Item not found'));
      } else {
        emit(CompanyItemDetailLoaded(detail));
      }
    } catch (e) {
      emit(CompanyItemDetailError(e.toString()));
    }
  }
}
