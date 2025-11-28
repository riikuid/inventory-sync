// lib/features/inventory/presentation/bloc/product_list_cubit/product_list_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../sync/data/sync_repository.dart';
import '../../../data/inventory_repository.dart';

part 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final InventoryRepository repository;
  final SyncRepository syncRepository;

  ProductListCubit(this.repository, this.syncRepository)
    : super(ProductListInitial());

  Future<void> load({String? search}) async {
    emit(ProductListLoading());
    try {
      // 1. coba sync dulu (silent failure, tetap lanjut kalau gagal)
      await syncRepository.pullSinceLast();

      // 2. baru ambil data lokal
      final products = await repository.getProductList(search: search);
      if (products.isEmpty) {
        emit(ProductListEmpty());
      } else {
        emit(ProductListLoaded(products));
      }
    } catch (e) {
      emit(ProductListError(e.toString()));
    }
  }
}
