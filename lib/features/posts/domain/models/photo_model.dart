class PhotoModel {
  const PhotoModel({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'albumId': albumId,
      'id': id,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  factory PhotoModel.fromJson(Map<String, dynamic> map) {
    return PhotoModel(
      albumId: (map['albumId'] ?? 0) as int,
      id: (map['id'] ?? 0) as int,
      title: (map['title'] ?? '') as String,
      url: (map['url'] ?? '') as String,
      thumbnailUrl: (map['thumbnailUrl'] ?? '') as String,
    );
  }
}
