import 'package:flutter/material.dart';
import 'package:flutter_tech_task/data/models/post_model.dart';
import 'package:flutter_tech_task/presentation/widgets/offline_status_banner.dart';
import 'package:flutter_tech_task/presentation/widgets/post_details_widgte.dart';
import '../../l10n/app_localizations.dart';

/// A widget that handles post content display with offline status
/// Following Single Responsibility Principle - only handles content presentation
class PostContentWidget extends StatelessWidget {
  const PostContentWidget({
    Key? key,
    required this.post,
    required this.isConnected,
    this.showOfflineBanner = true,
  }) : super(key: key);

  final Post post;
  final bool isConnected;
  final bool showOfflineBanner;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!isConnected && showOfflineBanner)
          OfflineStatusBanner(
            message: AppLocalizations.of(context)!.offlineModeShowingSavedPost,
            icon: Icons.wifi_off,
            backgroundColor: Colors.orange.shade100,
            borderColor: Colors.orange.shade300,
            textColor: Colors.orange.shade700,
            iconColor: Colors.orange.shade700,
          ),
        Expanded(
          child: PostDetails(post: post),
        ),
      ],
    );
  }
}