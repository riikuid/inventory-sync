class ComponentRequest {
  final String name;
  final int type;
  final String? manufCode;
  final String? specification;
  final List<String> pathPhotos;

  ComponentRequest({
    required this.name,
    required this.type,
    this.manufCode,
    this.specification,
    required this.pathPhotos,
  });
  // final int quantityNeeeded;
}
