import 'package:flutter/material.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';

/// Single post list item widget
class PostListItem extends StatelessWidget {
  const PostListItem({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed('details/', arguments: {'id': post.id});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(post.body),
            const SizedBox(height: 10),
            const Divider(thickness: 1, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}