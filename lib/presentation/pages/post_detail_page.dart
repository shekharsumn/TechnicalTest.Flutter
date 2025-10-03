import 'package:flutter/material.dart';
import 'package:flutter_tech_task/data/service/dio_service.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/utils/api_error.dart';
import 'package:dart_either/dart_either.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final postId = args?['id'] ?? 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post details'),
      ),
      body: FutureBuilder<Either<ApiError, Post>>(
        future: DioService().getPostById(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No data available'),
            );
          }

          final either = snapshot.data!;
          return either.fold(
            ifLeft: (ApiError err) => Center(child: Text(err.message)),
            ifRight: (Post post) => PostDetails(post: post),
          );
        },
      ),
    );
  }
}

/// Separate widget for displaying post details
class PostDetails extends StatelessWidget {
  const PostDetails({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Text(post.body, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}