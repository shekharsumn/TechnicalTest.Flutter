

/// A model representing a comment, typically used for parsing and serializing comment data.
class CommentModel {

  /// Creates a [CommentModel] instance with the given properties.
  ///
  /// All parameters are required and must not be null.
  CommentModel({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  /// Creates a [CommentModel] instance from a JSON map.
  /// 
  /// Expects a map with keys: 'postId', 'id', 'name', 'email', and 'body'.
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      postId: json['postId'] is int
          ? json['postId']
          : int.tryParse(json['postId'].toString()) ?? 0,
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
    );
  }

  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  /// Converts the [CommentModel] instance into a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'id': id,
      'name': name,
      'email': email,
      'body': body,
    };
  }
}