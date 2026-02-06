class PermissionSet {
  final Set<String> items;
  final int? version; // null kalau backend belum kirim versi

  const PermissionSet(this.items, {this.version});

  bool has(String key) => items.contains(key);
  bool anyOf(Iterable<String> keys) => keys.any(items.contains);
  bool allOf(Iterable<String> keys) => keys.every(items.contains);

  Map<String, dynamic> toJson() => {
    'version': version,
    'items': items.toList(),
  };

  factory PermissionSet.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List?)?.cast<String>() ?? <String>[];
    return PermissionSet(list.toSet(), version: json['version'] as int?);
  }
}
