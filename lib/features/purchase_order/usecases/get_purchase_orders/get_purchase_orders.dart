import 'package:inventory_sync_apps/core/result.dart';
import 'package:inventory_sync_apps/core/usecase.dart';
import 'package:inventory_sync_apps/features/purchase_order/models/purchase_order.dart';
import 'package:inventory_sync_apps/features/purchase_order/services/purchase_order_service.dart';

part 'get_purchase_orders_params.dart';

class GetPurchaseOrders
    implements UseCase<Result<List<PurchaseOrder>>, GetPurchaseOrdersParams> {
  GetPurchaseOrders();

  final PurchaseOrderService _repository = PurchaseOrderService();

  @override
  Future<Result<List<PurchaseOrder>>> call(
    GetPurchaseOrdersParams params,
  ) async {
    var result = await _repository.getPurchaseOrders(params);

    return result;
  }
}
