import 'dart:convert';
import 'package:inventory_sync_apps/features/purchase_order/models/purchase_order_item.dart';

class PurchaseOrder {
  String? purchaseOrderCode;
  int? typePo;
  String? typePoLabel;
  int? totalItem;
  int? totalItemProcess;
  int? totalItemReceived;
  String? statusInput;
  DateTime? poDate;
  String? delivery;
  dynamic estimedReceived;
  dynamic descEstimed;
  String? supplierName;
  String? supplierAddress;
  String? supplierCity;
  int? idSection;
  String? sectionName;
  String? sectionAlias;
  String? priorityPo;
  int? totalItemsQuantity;
  int? totalItemReceivedQuantity;
  List<PurchaseOrderItem>? items;

  PurchaseOrder({
    this.purchaseOrderCode,
    this.typePo,
    this.typePoLabel,
    this.totalItem,
    this.totalItemProcess,
    this.totalItemReceived,
    this.statusInput,
    this.poDate,
    this.delivery,
    this.estimedReceived,
    this.descEstimed,
    this.supplierName,
    this.supplierAddress,
    this.supplierCity,
    this.idSection,
    this.sectionName,
    this.sectionAlias,
    this.priorityPo,
    this.totalItemsQuantity,
    this.totalItemReceivedQuantity,
    this.items,
  });

  PurchaseOrder copyWith({
    String? purchaseOrderCode,
    int? typePo,
    String? typePoLabel,
    int? totalItem,
    int? totalItemProcess,
    int? totalItemReceived,
    String? statusInput,
    DateTime? poDate,
    String? delivery,
    dynamic estimedReceived,
    dynamic descEstimed,
    String? supplierName,
    String? supplierAddress,
    String? supplierCity,
    int? idSection,
    String? sectionName,
    String? sectionAlias,
    String? priorityPo,
    int? totalItemsQuantity,
    int? totalItemReceivedQuantity,
    List<PurchaseOrderItem>? items,
  }) => PurchaseOrder(
    purchaseOrderCode: purchaseOrderCode ?? this.purchaseOrderCode,
    typePo: typePo ?? this.typePo,
    typePoLabel: typePoLabel ?? this.typePoLabel,
    totalItem: totalItem ?? this.totalItem,
    totalItemProcess: totalItemProcess ?? this.totalItemProcess,
    totalItemReceived: totalItemReceived ?? this.totalItemReceived,
    statusInput: statusInput ?? this.statusInput,
    poDate: poDate ?? this.poDate,
    delivery: delivery ?? this.delivery,
    estimedReceived: estimedReceived ?? this.estimedReceived,
    descEstimed: descEstimed ?? this.descEstimed,
    supplierName: supplierName ?? this.supplierName,
    supplierAddress: supplierAddress ?? this.supplierAddress,
    supplierCity: supplierCity ?? this.supplierCity,
    idSection: idSection ?? this.idSection,
    sectionName: sectionName ?? this.sectionName,
    sectionAlias: sectionAlias ?? this.sectionAlias,
    priorityPo: priorityPo ?? this.priorityPo,
    totalItemsQuantity: totalItemsQuantity ?? this.totalItemsQuantity,
    totalItemReceivedQuantity:
        totalItemReceivedQuantity ?? this.totalItemReceivedQuantity,
    items: items ?? this.items,
  );

  factory PurchaseOrder.fromRawJson(String str) =>
      PurchaseOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) => PurchaseOrder(
    purchaseOrderCode: json["purchase_order_code"],
    typePo: json["type_po"],
    typePoLabel: json["type_po_label"],
    totalItem: json["total_item"],
    totalItemProcess: json["total_item_process"],
    totalItemReceived: json["total_item_received"],
    statusInput: json["status_input"],
    poDate: json["po_date"] == null ? null : DateTime.parse(json["po_date"]),
    delivery: json["delivery"],
    estimedReceived: json["estimed_received"],
    descEstimed: json["desc_estimed"],
    supplierName: json["supplier_name"],
    supplierAddress: json["supplier_address"],
    supplierCity: json["supplier_city"],
    idSection: json["id_section"],
    sectionName: json["section_name"],
    sectionAlias: json["section_alias"],
    priorityPo: json["priority_po"],
    totalItemsQuantity: json["total_items_quantity"],
    totalItemReceivedQuantity: json["total_item_received_quantity"],
    items: json["items"] == null
        ? []
        : List<PurchaseOrderItem>.from(
            json["items"]!.map((x) => PurchaseOrderItem.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "purchase_order_code": purchaseOrderCode,
    "type_po": typePo,
    "type_po_label": typePoLabel,
    "total_item": totalItem,
    "total_item_process": totalItemProcess,
    "total_item_received": totalItemReceived,
    "status_input": statusInput,
    "po_date": poDate?.toIso8601String(),
    "delivery": delivery,
    "estimed_received": estimedReceived,
    "desc_estimed": descEstimed,
    "supplier_name": supplierName,
    "supplier_address": supplierAddress,
    "supplier_city": supplierCity,
    "id_section": idSection,
    "section_name": sectionName,
    "section_alias": sectionAlias,
    "priority_po": priorityPo,
    "total_items_quantity": totalItemsQuantity,
    "total_item_received_quantity": totalItemReceivedQuantity,
    "items": items == null
        ? []
        : List<PurchaseOrderItem>.from(items!.map((x) => x.toJson())),
  };
}
