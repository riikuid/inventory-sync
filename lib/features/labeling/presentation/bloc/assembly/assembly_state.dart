// lib/features/labeling/presentation/bloc/assembly/assembly_state.dart

import 'package:equatable/equatable.dart';

class AssemblyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AssemblyReady extends AssemblyState {
  final String variantId;
  final String variantName;

  // ⬇️ komponen yg wajib ada di set
  final List<String> requiredComponentIds;

  // map: componentId -> hasil scan (tipe bebas, ikut return scanUnitByQr)
  final Map<String, dynamic> scannedByComponentId;

  final bool isSaving;
  final String? errorMessage;
  final dynamic assemblyResult; // tipe sesuai hasil assembleComponents

  bool get isCompleted =>
      requiredComponentIds.isNotEmpty &&
      scannedByComponentId.length == requiredComponentIds.length;

  bool get canAssemble => !isSaving && isCompleted;

  AssemblyReady({
    required this.variantId,
    required this.variantName,
    required this.requiredComponentIds,
    Map<String, dynamic>? scannedByComponentId,
    this.isSaving = false,
    this.errorMessage,
    this.assemblyResult,
  }) : scannedByComponentId = scannedByComponentId ?? {};

  AssemblyReady copyWith({
    String? variantId,
    String? variantName,
    List<String>? requiredComponentIds,
    Map<String, dynamic>? scannedByComponentId,
    bool? isSaving,
    String? errorMessage,
    dynamic assemblyResult,
  }) {
    return AssemblyReady(
      variantId: variantId ?? this.variantId,
      variantName: variantName ?? this.variantName,
      requiredComponentIds: requiredComponentIds ?? this.requiredComponentIds,
      scannedByComponentId: scannedByComponentId ?? this.scannedByComponentId,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      assemblyResult: assemblyResult ?? this.assemblyResult,
    );
  }

  @override
  List<Object?> get props => [
    variantId,
    variantName,
    requiredComponentIds,
    scannedByComponentId,
    isSaving,
    errorMessage,
    assemblyResult,
  ];
}

class AssemblyError extends AssemblyState {
  final String message;

  AssemblyError(this.message);

  @override
  List<Object?> get props => [message];
}
