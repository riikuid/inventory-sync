// // lib/features/labeling/presentation/bloc/label_component/label_component_state.dart
// import 'package:equatable/equatable.dart';

// class LabelComponentState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class LabelComponentInitial extends LabelComponentState {}

// class LabelComponentReady extends LabelComponentState {
//   final String variantId;
//   final String variantName;
//   final String componentId;
//   final String componentName;
//   final String? defaultLocation;

//   final int quantity;
//   final String? location;
//   final bool isSaving;
//   final String? sampleQr; // contoh QR dari hasil generate terakhir

//   LabelComponentReady({
//     required this.variantId,
//     required this.variantName,
//     required this.componentId,
//     required this.componentName,
//     this.defaultLocation,
//     this.quantity = 1,
//     this.location,
//     this.isSaving = false,
//     this.sampleQr,
//   });

//   LabelComponentReady copyWith({
//     int? quantity,
//     String? location,
//     bool? isSaving,
//     String? sampleQr,
//   }) {
//     return LabelComponentReady(
//       variantId: variantId,
//       variantName: variantName,
//       componentId: componentId,
//       componentName: componentName,
//       defaultLocation: defaultLocation,
//       quantity: quantity ?? this.quantity,
//       location: location ?? this.location,
//       isSaving: isSaving ?? this.isSaving,
//       sampleQr: sampleQr ?? this.sampleQr,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     variantId,
//     variantName,
//     componentId,
//     componentName,
//     defaultLocation,
//     quantity,
//     location,
//     isSaving,
//     sampleQr,
//   ];
// }

// class LabelComponentSuccess extends LabelComponentState {
//   final int generatedCount;
//   final String? sampleQr;

//   LabelComponentSuccess({required this.generatedCount, this.sampleQr});

//   @override
//   List<Object?> get props => [generatedCount, sampleQr];
// }

// class LabelComponentError extends LabelComponentState {
//   final String message;

//   LabelComponentError(this.message);

//   @override
//   List<Object?> get props => [message];
// }
