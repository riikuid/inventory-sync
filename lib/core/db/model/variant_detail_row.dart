import 'photo_row.dart';
import 'variant_component_row.dart';

class VariantDetailRow {
  final String variantId;

  // TAMBAHAN: ID incremental Variant dari server
  final int? variantRemoteId;

  final String companyItemId;
  final String productId;
  final String companyCode;
  final String name;
  final String uom;
  final String uomId;
  final String? manufCode;
  final String? specification;
  final String? rackId;
  final String? rackName;
  final String? brandId;
  final String? brandName;
  final List<PhotoRow> photos;
  final int
  totalUnits; // semua unit ACTIVE untuk variant ini (component_id IS NULL)
  final List<VariantComponentRow> componentsInBox;
  final List<VariantComponentRow> componentsSeparate;

  VariantDetailRow({
    required this.variantId,
    this.variantRemoteId,
    required this.companyItemId,
    required this.productId,
    required this.name,
    required this.uom,
    required this.uomId,
    this.manufCode,
    this.brandId,
    this.brandName,
    this.rackId,
    this.rackName,
    this.specification,
    required this.companyCode,
    required this.photos,
    required this.totalUnits,
    required this.componentsSeparate,
    required this.componentsInBox,
  });
}
