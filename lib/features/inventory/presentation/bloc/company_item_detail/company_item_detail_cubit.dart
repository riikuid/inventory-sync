import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/inventory_repository.dart';

part 'company_item_detail_state.dart';

class CompanyItemDetailCubit extends Cubit<CompanyItemDetailState> {
  final InventoryRepository repository;

  CompanyItemDetailCubit(this.repository) : super(CompanyItemDetailInitial());

  Future<void> loadDetail(String companyItemId) async {
    emit(CompanyItemDetailLoading());
    try {
      final detail = await repository.getCompanyItemDetail(companyItemId);
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
