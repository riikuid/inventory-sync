import 'package:inventory_sync_apps/core/result.dart';
import 'package:inventory_sync_apps/core/usecase.dart';
import 'package:inventory_sync_apps/features/purchase_order/models/purchase_order.dart';
import 'package:inventory_sync_apps/features/purchase_order/services/purchase_order_service.dart';

class GetDetailPurchaseOrder implements UseCase<Result<PurchaseOrder>, String> {
  GetDetailPurchaseOrder();

  final PurchaseOrderService _service = PurchaseOrderService();

  @override
  Future<Result<PurchaseOrder>> call(String id) async {
    var result = await _service.getDetailPurchaseOrder(id);

    return result;
  }
}
