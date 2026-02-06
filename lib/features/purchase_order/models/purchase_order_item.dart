import 'dart:convert';

class PurchaseOrderItem {
  String? purchaseOrderCode;
  int? purchaseOrderDetailId;
  String? statusPurchaseDetail;
  int? requestDetailId;
  String? itemCode;
  String? itemName;
  String? descriptionPoDetail;
  String? requestCode;
  String? requestStatus;
  int? qtyRequest;
  int? qtyPurchase;
  int? qtyReceived;
  int? sisa;
  String? uomName;
  int? uomId;
  int? smallestUomId;
  int? price;

  PurchaseOrderItem({
    this.purchaseOrderCode,
    this.purchaseOrderDetailId,
    this.statusPurchaseDetail,
    this.requestDetailId,
    this.itemCode,
    this.itemName,
    this.descriptionPoDetail,
    this.requestCode,
    this.requestStatus,
    this.qtyRequest,
    this.qtyPurchase,
    this.qtyReceived,
    this.sisa,
    this.uomName,
    this.uomId,
    this.smallestUomId,
    this.price,
  });

  PurchaseOrderItem copyWith({
    String? purchaseOrderCode,
    int? purchaseOrderDetailId,
    String? statusPurchaseDetail,
    int? requestDetailId,
    String? itemCode,
    String? itemName,
    String? descriptionPoDetail,
    String? requestCode,
    String? requestStatus,
    int? qtyRequest,
    int? qtyPurchase,
    int? qtyReceived,
    int? sisa,
    String? uomName,
    int? uomId,
    int? smallestUomId,
    int? price,
  }) => PurchaseOrderItem(
    purchaseOrderCode: purchaseOrderCode ?? this.purchaseOrderCode,
    purchaseOrderDetailId: purchaseOrderDetailId ?? this.purchaseOrderDetailId,
    statusPurchaseDetail: statusPurchaseDetail ?? this.statusPurchaseDetail,
    requestDetailId: requestDetailId ?? this.requestDetailId,
    itemCode: itemCode ?? this.itemCode,
    itemName: itemName ?? this.itemName,
    descriptionPoDetail: descriptionPoDetail ?? this.descriptionPoDetail,
    requestCode: requestCode ?? this.requestCode,
    requestStatus: requestStatus ?? this.requestStatus,
    qtyRequest: qtyRequest ?? this.qtyRequest,
    qtyPurchase: qtyPurchase ?? this.qtyPurchase,
    qtyReceived: qtyReceived ?? this.qtyReceived,
    sisa: sisa ?? this.sisa,
    uomName: uomName ?? this.uomName,
    uomId: uomId ?? this.uomId,
    smallestUomId: smallestUomId ?? this.smallestUomId,
    price: price ?? this.price,
  );

  factory PurchaseOrderItem.fromRawJson(String str) =>
      PurchaseOrderItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseOrderItem.fromJson(Map<String, dynamic> json) =>
      PurchaseOrderItem(
        purchaseOrderCode: json["purchase_order_code"],
        purchaseOrderDetailId: json["purchase_order_detail_id"],
        statusPurchaseDetail: json["status_purchase_detail"],
        requestDetailId: json["request_detail_id"],
        itemCode: json["item_code"],
        itemName: json["item_name"],
        descriptionPoDetail: json["description_po_detail"],
        requestCode: json["request_code"],
        requestStatus: json["request_status"],
        qtyRequest: json["qty_request"],
        qtyPurchase: json["qty_purchase"],
        qtyReceived: json["qty_received"],
        sisa: json["sisa"],
        uomName: json["uom_name"],
        uomId: json["uom_id"],
        smallestUomId: json["smallest_uom_id"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
    "purchase_order_code": purchaseOrderCode,
    "purchase_order_detail_id": purchaseOrderDetailId,
    "status_purchase_detail": statusPurchaseDetail,
    "request_detail_id": requestDetailId,
    "item_code": itemCode,
    "item_name": itemName,
    "description_po_detail": descriptionPoDetail,
    "request_code": requestCode,
    "request_status": requestStatus,
    "qty_request": qtyRequest,
    "qty_purchase": qtyPurchase,
    "qty_received": qtyReceived,
    "sisa": sisa,
    "uom_name": uomName,
    "uom_id": uomId,
    "smallest_uom_id": smallestUomId,
    "price": price,
  };
}
