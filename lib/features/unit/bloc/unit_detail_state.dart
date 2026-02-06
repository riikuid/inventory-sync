// lib/features/inventory/presentation/bloc/variant_detail/variant_detail_state.dart
part of 'unit_detail_cubit.dart';

abstract class UnitDetailState extends Equatable {
  const UnitDetailState();

  @override
  List<Object?> get props => [];
}

class UnitDetailInitial extends UnitDetailState {}

class UnitDetailLoading extends UnitDetailState {}

class UnitDetailLoaded extends UnitDetailState {
  final UnitWithRelations detail;
  final bool isBusy;
  final String? errorMessage;

  const UnitDetailLoaded({
    required this.detail,
    this.isBusy = false,
    this.errorMessage,
  });

  UnitDetailLoaded copyWith({
    UnitWithRelations? detail,
    bool? isBusy,
    String? errorMessage,
  }) {
    return UnitDetailLoaded(
      detail: detail ?? this.detail,
      isBusy: isBusy ?? this.isBusy,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [detail, isBusy, errorMessage];
}

class UnitDetailError extends UnitDetailState {
  final String message;
  const UnitDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
