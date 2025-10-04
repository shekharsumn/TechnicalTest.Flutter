import 'package:dio/dio.dart';
import 'package:dart_either/dart_either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/utils/api_error.dart';

import '../../data/models/post_model.dart';
import '../../data/models/comment_model.dart';
import 'api_interface.dart';

/// Riverpod provider for the API service
final dioServiceProvider = Provider<ApiInterface>((ref) {
  return DioService();
});

class DioService implements ApiInterface {

  DioService({Dio? dio, String? baseUrl})
      : _dio = dio ?? Dio(BaseOptions(
          baseUrl: baseUrl ?? 'https://jsonplaceholder.typicode.com',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'User-Agent': 'Flutter-App/1.0.0',
            'Cache-Control': 'no-cache',
          },
        ));

  final Dio _dio;

  @override
  Future<Either<ApiError, List<Post>>> getPosts() async {
    try {
      final Response response = await _dio.get('/posts');
      final List<dynamic> data = response.data as List<dynamic>;
      final List<Post> posts = data.map((dynamic j) => Post.fromJson(j as Map<String, dynamic>)).toList();
      return Right(posts);
    } on DioException catch (e) {
      return Left(ApiError.fromDio(e));
    }
  }

  @override
  Future<Either<ApiError, Post>> getPostById(int id) async {
    try {
      final Response response = await _dio.get('/posts/$id');
      final Post post = Post.fromJson(response.data as Map<String, dynamic>);
      return Right(post);
    } on DioException catch (e) {
      return Left(ApiError.fromDio(e));
    }
  }

  @override
  Future<Either<ApiError, List<CommentModel>>> getCommentsForPost(int postId) async {
    try {
      final Response response = await _dio.get('/posts/$postId/comments');
      final List<dynamic> data = response.data as List<dynamic>;
      final List<CommentModel> comments =
          data.map((dynamic j) => CommentModel.fromJson(j as Map<String, dynamic>)).toList();
      return Right(comments);
    } on DioException catch (e) {
      return Left(ApiError.fromDio(e));
    }
  }
}

