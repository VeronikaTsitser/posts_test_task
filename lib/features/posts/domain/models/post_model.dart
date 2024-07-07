class PostModel {
  const PostModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  final int userId;
  final int id;
  final String title;
  final String body;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> map) {
    return PostModel(
      userId: (map['userId'] ?? 0) as int,
      id: (map['id'] ?? 0) as int,
      title: (map['title'] ?? '') as String,
      body: (map['body'] ?? '') as String,
    );
  }
}
