class SelectedRackResult {
  final String id;
  final String name;
  final String? warehouseName;
  final String? sectionName;
  final String? departmentName;

  SelectedRackResult({
    required this.id,
    required this.name,
    this.warehouseName,
    this.sectionName,
    this.departmentName,
  });
}
