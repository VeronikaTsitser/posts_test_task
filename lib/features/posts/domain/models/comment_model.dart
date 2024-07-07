class CommentModel {
  const CommentModel({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'postId': postId,
      'id': id,
      'name': name,
      'email': email,
      'body': body,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> map) {
    return CommentModel(
      postId: (map['postId'] ?? 0) as int,
      id: (map['id'] ?? 0) as int,
      name: (map['name'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      body: (map['body'] ?? '') as String,
    );
  }
}
