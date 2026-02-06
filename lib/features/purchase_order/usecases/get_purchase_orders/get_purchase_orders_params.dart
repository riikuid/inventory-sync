part of 'get_purchase_orders.dart';

class GetPurchaseOrdersParams {
  int? page, limit;
  // String? startDate, endDate;
  String? status;
  List<String>? sectionIds;
  String? search;

  GetPurchaseOrdersParams({
    this.page,
    this.limit,
    // this.startDate,
    // this.endDate,
    this.status,
    this.sectionIds,
    this.search,
  });
}
