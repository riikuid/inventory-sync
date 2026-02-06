import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'receiving_session_state.dart';

class ReceivingSessionCubit extends Cubit<ReceivingSessionState> {
  ReceivingSessionCubit() : super(const ReceivingSessionState());

  /// Memulai sesi penerimaan barang dari PO
  void startSession({
    required String poNumber,
    required int poDetailId,
    required String itemCode,
    required String itemName,
    required int qtyRemaining,
    required int purchasingUomId,
    required String purchasingUomName,
    required int setPrice,
  }) {
    emit(
      state.copyWith(
        isActive: true,
        poNumber: poNumber,
        poDetailId: poDetailId,
        itemCode: itemCode,
        itemName: itemName,
        qtyRemaining: qtyRemaining,
        qtyProcessed: 0,
        purchasingUomId: purchasingUomId,
        purchasingUomName: purchasingUomName,
        setPrice: setPrice,
      ),
    );
  }

  /// Update sisa qty (dipanggil setelah sukses submit ke API)
  void decreaseRemainingQty(int amountProcessed) {
    final newRemaining = state.qtyRemaining - amountProcessed;
    emit(
      state.copyWith(
        qtyRemaining: newRemaining < 0 ? 0 : newRemaining,
        qtyProcessed: state.qtyProcessed + amountProcessed,
      ),
    );
  }

  /// Mengakhiri sesi (reset state)
  void clearSession() {
    emit(const ReceivingSessionState(isActive: false));
  }
}
