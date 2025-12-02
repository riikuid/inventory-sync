// lib/features/inventory/presentation/bloc/variant_detail/variant_detail_state.dart
import 'package:equatable/equatable.dart';

import '../../../../../core/db/daos/variant_dao.dart';

abstract class VariantDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VariantDetailInitial extends VariantDetailState {}

class VariantDetailLoading extends VariantDetailState {}

class VariantDetailLoaded extends VariantDetailState {
  final VariantDetailRow detail;
  final bool isBusy;
  final String? errorMessage;

  VariantDetailLoaded({
    required this.detail,
    this.isBusy = false,
    this.errorMessage,
  });

  VariantDetailLoaded copyWith({
    VariantDetailRow? detail,
    bool? isBusy,
    String? errorMessage,
  }) {
    return VariantDetailLoaded(
      detail: detail ?? this.detail,
      isBusy: isBusy ?? this.isBusy,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [detail, isBusy, errorMessage];
}

class VariantDetailError extends VariantDetailState {
  final String message;
  VariantDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
