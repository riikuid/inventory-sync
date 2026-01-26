// import 'package:equatable/equatable.dart';

// enum LabelMode { set, component }

// class LabelSetState extends Equatable {
//   final String variantId;
//   final String? variantName;
//   final String? brandName;
//   final String? defaultLocation;

//   final LabelMode mode;

//   final String? qrValue;
//   final bool isGenerated;
//   final bool isScanConfirmed;

//   final bool isSaving;
//   final bool isSuccess;
//   final String? errorMessage;

//   const LabelSetState({
//     required this.variantId,
//     this.variantName,
//     this.brandName,
//     this.defaultLocation,
//     this.mode = LabelMode.set,
//     this.qrValue,
//     this.isGenerated = false,
//     this.isScanConfirmed = false,
//     this.isSaving = false,
//     this.isSuccess = false,
//     this.errorMessage,
//   });

//   factory LabelSetState.initial({
//     required String variantId,
//     String? variantName,
//     String? brandName,
//     String? defaultLocation,
//   }) {
//     return LabelSetState(
//       variantId: variantId,
//       variantName: variantName,
//       brandName: brandName,
//       defaultLocation: defaultLocation,
//       qrValue: null,
//       isGenerated: false,
//       isScanConfirmed: false,
//       isSaving: false,
//       isSuccess: false,
//       errorMessage: null,
//     );
//   }

//   LabelSetState copyWith({
//     String? qrValue,
//     bool? isGenerated,
//     bool? isScanConfirmed,
//     bool? isSaving,
//     bool? isSuccess,
//     String? errorMessage,
//     LabelMode? mode,
//   }) {
//     return LabelSetState(
//       variantId: variantId,
//       variantName: variantName,
//       brandName: brandName,
//       defaultLocation: defaultLocation,
//       mode: mode ?? this.mode,
//       qrValue: qrValue ?? this.qrValue,
//       isGenerated: isGenerated ?? this.isGenerated,
//       isScanConfirmed: isScanConfirmed ?? this.isScanConfirmed,
//       isSaving: isSaving ?? this.isSaving,
//       isSuccess: isSuccess ?? this.isSuccess,
//       errorMessage: errorMessage,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     variantId,
//     variantName,
//     brandName,
//     defaultLocation,
//     qrValue,
//     isGenerated,
//     isScanConfirmed,
//     isSaving,
//     isSuccess,
//     errorMessage,
//   ];
// }
