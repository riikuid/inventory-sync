/// DTO untuk list hasil search
class InventorySearchItem {
  final String companyItemId;
  final String companyCode;
  final String productName;

  /// kategori utama (parent = null) yang dimiliki product ini
  final String? categoryId;
  final String? categoryName;

  final String? rackName;
  final String? warehouseName;
  final int variantCount;
  final bool? isLabeled;

  InventorySearchItem({
    required this.companyItemId,
    required this.companyCode,
    required this.productName,
    this.categoryId,
    this.categoryName,
    this.rackName,
    this.warehouseName,
    required this.variantCount,
    this.isLabeled = false,
  });
}
