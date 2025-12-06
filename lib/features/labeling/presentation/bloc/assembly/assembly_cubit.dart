// // lib/features/labeling/presentation/bloc/assembly/assembly_cubit.dart
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../data/labeling_repository.dart';
// import 'assembly_state.dart';

// class AssemblyCubit extends Cubit<AssemblyState> {
//   final LabelingRepository labelingRepository;
//   final String userId;

//   AssemblyCubit({
//     required this.labelingRepository,
//     required String variantId,
//     required String variantName,
//     required List<String> componentIds, // ⬅️ daftar komponen di variant ini
//     required this.userId,
//   }) : super(
//          AssemblyReady(
//            variantId: variantId,
//            variantName: variantName,
//            requiredComponentIds: componentIds,
//          ),
//        );

//   /// Scan satu QR; cubit yang akan memutuskan ini masuk komponen mana.
//   Future<void> scanComponent(String qrValue) async {
//     final s = state;
//     if (s is! AssemblyReady) return;

//     try {
//       final result = await labelingRepository.scanUnitByQr(qrValue);
//       if (result == null) {
//         emit(s.copyWith(errorMessage: 'QR tidak ditemukan'));
//         return;
//       }
//       if (result.status != 'ACTIVE') {
//         emit(
//           s.copyWith(
//             errorMessage:
//                 'QR ini tidak dapat dipakai (status: ${result.status})',
//           ),
//         );
//         return;
//       }
//       if (result.componentId == null) {
//         emit(s.copyWith(errorMessage: 'QR ini bukan unit komponen'));
//         return;
//       }

//       final componentId = result.componentId as String;

//       // validasi: komponen ini memang bagian dari set
//       if (!s.requiredComponentIds.contains(componentId)) {
//         emit(
//           s.copyWith(
//             errorMessage:
//                 'Unit ini bukan komponen yang terdaftar di set untuk variant ini.',
//           ),
//         );
//         return;
//       }

//       // validasi: jangan pakai 2 unit untuk komponen yang sama
//       if (s.scannedByComponentId.containsKey(componentId)) {
//         emit(
//           s.copyWith(
//             errorMessage: 'Komponen ini sudah discan. Scan komponen lain.',
//           ),
//         );
//         return;
//       }

//       final updatedMap = Map<String, dynamic>.from(s.scannedByComponentId)
//         ..[componentId] = result;

//       emit(s.copyWith(scannedByComponentId: updatedMap, errorMessage: null));
//     } catch (e) {
//       emit(AssemblyError(e.toString()));
//     }
//   }

//   Future<void> assemble({String? location}) async {
//     final s = state;
//     if (s is! AssemblyReady) return;

//     if (!s.canAssemble) {
//       emit(
//         s.copyWith(
//           errorMessage:
//               'Belum semua komponen discan (${s.scannedByComponentId.length}/${s.requiredComponentIds.length}).',
//         ),
//       );
//       return;
//     }

//     emit(s.copyWith(isSaving: true, errorMessage: null));

//     try {
//       final unitIds = s.scannedByComponentId.values
//           .map((e) => e.unitId as String)
//           .toList();

//       final result = await labelingRepository.assembleComponents(
//         variantId: s.variantId,
//         componentUnitIds: unitIds,
//         userId: userId,
//         location: location,
//       );

//       emit(
//         s.copyWith(isSaving: false, assemblyResult: result, errorMessage: null),
//       );
//     } catch (e) {
//       emit(s.copyWith(isSaving: false, errorMessage: e.toString()));
//     }
//   }
// }
