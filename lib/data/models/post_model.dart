class Post {
  Post(
      {required this.id,
      required this.userId,
      required this.title,
      required this.body});

  /// Creates a [Post] instance from a JSON object.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
  final int id;
  final int userId;
  final String title;
  final String body;

  /// Converts this [Post] instance into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
