// lib/features/labeling/presentation/bloc/assembly/assembly_state.dart
import 'package:equatable/equatable.dart';

import '../../../data/models/scan_unit_result.dart';
import '../../../data/models/assembly_result.dart';

class AssemblyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AssemblyInitial extends AssemblyState {}

class AssemblyReady extends AssemblyState {
  final String variantId;
  final String variantName;

  final ScanUnitResult? componentA;
  final ScanUnitResult? componentB;

  final bool isSaving;
  final AssemblyResult? assemblyResult;
  final String? errorMessage;

  bool get canAssemble =>
      componentA != null &&
      componentB != null &&
      !isSaving &&
      assemblyResult == null;

  AssemblyReady({
    required this.variantId,
    required this.variantName,
    this.componentA,
    this.componentB,
    this.isSaving = false,
    this.assemblyResult,
    this.errorMessage,
  });

  AssemblyReady copyWith({
    ScanUnitResult? componentA,
    bool clearComponentA = false,
    ScanUnitResult? componentB,
    bool clearComponentB = false,
    bool? isSaving,
    AssemblyResult? assemblyResult,
    String? errorMessage,
  }) {
    return AssemblyReady(
      variantId: variantId,
      variantName: variantName,
      componentA: clearComponentA ? null : (componentA ?? this.componentA),
      componentB: clearComponentB ? null : (componentB ?? this.componentB),
      isSaving: isSaving ?? this.isSaving,
      assemblyResult: assemblyResult ?? this.assemblyResult,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    variantId,
    variantName,
    componentA,
    componentB,
    isSaving,
    assemblyResult,
    errorMessage,
  ];
}

class AssemblyError extends AssemblyState {
  final String message;
  AssemblyError(this.message);

  @override
  List<Object?> get props => [message];
}
