// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:uuid/uuid.dart';

// import '../../../data/labeling_repository.dart';
// import 'label_set_state.dart';

// class LabelSetCubit extends Cubit<LabelSetState> {
//   final LabelingRepository labelingRepository;
//   final String userId;
//   final _uuid = const Uuid();

//   LabelSetCubit({
//     required this.labelingRepository,
//     required String variantId,
//     String? variantName,
//     String? brandName,
//     String? defaultLocation,
//     required this.userId,
//   }) : super(
//          LabelSetState.initial(
//            variantId: variantId,
//            variantName: variantName,
//            brandName: brandName,
//            defaultLocation: defaultLocation,
//          ),
//        );

//   void generateQr() {
//     final qr = 'UNIT-${_uuid.v4()}'; // simple & unik, nanti backend bisa parse
//     emit(
//       state.copyWith(
//         qrValue: qr,
//         isGenerated: true,
//         isScanConfirmed: false,
//         errorMessage: null,
//       ),
//     );
//   }

//   /// Dipanggil setelah user scan QR fisik.
//   void confirmScan(String scannedValue) {
//     if (state.qrValue == null) {
//       emit(state.copyWith(errorMessage: 'QR belum dibuat'));
//       return;
//     }
//     if (scannedValue.trim() != state.qrValue!.trim()) {
//       emit(state.copyWith(errorMessage: 'QR tidak cocok, coba scan lagi'));
//       return;
//     }

//     emit(state.copyWith(isScanConfirmed: true, errorMessage: null));
//   }

//   Future<void> saveUnit({String? overrideLocation}) async {
//     if (!state.isGenerated || state.qrValue == null) {
//       emit(state.copyWith(errorMessage: 'Generate QR dulu'));
//       return;
//     }
//     if (!state.isScanConfirmed) {
//       emit(state.copyWith(errorMessage: 'QR belum dikonfirmasi scan'));
//       return;
//     }

//     emit(state.copyWith(isSaving: true, errorMessage: null));

//     try {
//       final loc = overrideLocation ?? state.defaultLocation;

//       await labelingRepository.createSetUnit(
//         variantId: state.variantId,
//         location: loc,
//         qrValue: state.qrValue!,
//         userId: userId,
//       );

//       emit(state.copyWith(isSaving: false, isSuccess: true));
//     } catch (e) {
//       emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
//     }
//   }
// }
