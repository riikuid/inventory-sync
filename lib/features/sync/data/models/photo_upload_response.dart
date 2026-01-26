class UploadPhotoResponse {
  final String id;
  final String filePath;
  final String? url;
  final String? type;

  UploadPhotoResponse({
    required this.id,
    required this.filePath,
    this.url,
    this.type,
  });

  factory UploadPhotoResponse.fromJson(Map<String, dynamic> json) {
    return UploadPhotoResponse(
      id: json['id'] as String,
      filePath: json['file_path'] as String,
      url: json['url'] as String?,
      type: json['type'] as String?,
    );
  }
}
