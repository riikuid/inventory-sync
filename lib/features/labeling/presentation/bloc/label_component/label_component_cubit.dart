// // lib/features/labeling/presentation/bloc/label_component/label_component_cubit.dart
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../data/labeling_repository.dart';
// import 'label_component_state.dart';

// class LabelComponentCubit extends Cubit<LabelComponentState> {
//   final LabelingRepository labelingRepository;
//   final String userId;

//   LabelComponentCubit({
//     required this.labelingRepository,
//     required String variantId,
//     required String variantName,
//     required String componentId,
//     required String componentName,
//     String? defaultLocation,
//     required this.userId,
//   }) : super(
//          LabelComponentReady(
//            variantId: variantId,
//            variantName: variantName,
//            componentId: componentId,
//            componentName: componentName,
//            defaultLocation: defaultLocation,
//            quantity: 1,
//            location: defaultLocation,
//          ),
//        );

//   void changeQuantity(int value) {
//     final s = state;
//     if (s is LabelComponentReady) {
//       final q = value < 1 ? 1 : value;
//       emit(s.copyWith(quantity: q));
//     }
//   }

//   void changeLocation(String? value) {
//     final s = state;
//     if (s is LabelComponentReady) {
//       emit(s.copyWith(location: value?.isEmpty == true ? null : value));
//     }
//   }

//   Future<void> submit() async {
//     final s = state;
//     if (s is! LabelComponentReady) return;

//     emit(s.copyWith(isSaving: true));

//     try {
//       final result = await labelingRepository.createComponentUnits(
//         variantId: s.variantId,
//         componentId: s.componentId,
//         quantity: s.quantity,
//         location: s.location ?? s.defaultLocation,
//         userId: userId,
//       );

//       emit(
//         LabelComponentSuccess(
//           generatedCount: result.generatedCount,
//           sampleQr: result.sampleQrValue,
//         ),
//       );
//     } catch (e) {
//       emit(LabelComponentError(e.toString()));
//       emit(s.copyWith(isSaving: false));
//     }
//   }
// }
