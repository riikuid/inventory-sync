// lib/features/inventory/presentation/bloc/variant_detail/variant_detail_state.dart
part of 'variant_detail_cubit.dart';

abstract class VariantDetailState extends Equatable {
  const VariantDetailState();

  @override
  List<Object?> get props => [];
}

class VariantDetailInitial extends VariantDetailState {}

class VariantDetailLoading extends VariantDetailState {}

class VariantDetailLoaded extends VariantDetailState {
  final VariantDetailRow detail;
  final bool isBusy;
  final String? errorMessage;

  const VariantDetailLoaded({
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
  const VariantDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
