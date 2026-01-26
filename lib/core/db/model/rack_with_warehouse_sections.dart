import 'section_info.dart';

class RackWithWarehouseAndSections {
  final String rackId;
  final String rackName;
  final String warehouseId;
  final String warehouseName;
  final List<SectionInfo> sections; // Sections yang terhubung ke warehouse ini

  RackWithWarehouseAndSections({
    required this.rackId,
    required this.rackName,
    required this.warehouseId,
    required this.warehouseName,
    required this.sections,
  });

  String get displayName => '$rackName - $warehouseName';

  // Get section codes untuk badge
  List<String> get sectionCodes => sections.map((s) => s.code).toList();
}
