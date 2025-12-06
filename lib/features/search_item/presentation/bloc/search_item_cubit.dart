import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../inventory/data/inventory_repository.dart';
import '../../../inventory/data/model/inventory_search_item.dart';

part 'search_item_state.dart';

class SearchItemCubit extends Cubit<SearchItemState> {
  final InventoryRepository repository;

  SearchItemCubit(this.repository) : super(SearchItemInitial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchItemInitial());
      return;
    }

    emit(SearchItemLoading());

    try {
      final items = await repository.searchItems(query);
      if (items.isEmpty) {
        emit(SearchItemEmpty());
      } else {
        emit(SearchItemLoaded(items));
      }
    } catch (e) {
      emit(SearchItemError(e.toString()));
    }
  }
}
