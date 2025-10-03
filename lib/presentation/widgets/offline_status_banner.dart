import 'package:flutter/material.dart';

/// A reusable banner widget to display offline status information
/// Eliminates duplicate offline notification UI patterns across the app
class OfflineStatusBanner extends StatelessWidget {
  const OfflineStatusBanner({
    Key? key,
    required this.message,
    this.icon = Icons.wifi_off,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.iconColor,
    this.margin = const EdgeInsets.all(8),
    this.padding = const EdgeInsets.all(12),
  }) : super(key: key);

  /// The message to display in the banner
  final String message;
  
  /// The icon to display (defaults to wifi_off)
  final IconData icon;
  
  /// Background color of the banner
  final Color? backgroundColor;
  
  /// Border color of the banner
  final Color? borderColor;
  
  /// Text color
  final Color? textColor;
  
  /// Icon color
  final Color? iconColor;
  
  /// Margin around the banner
  final EdgeInsets margin;
  
  /// Padding inside the banner
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final defaultOrangeShade = Colors.orange.shade700;
    
    return Container(
      width: double.infinity,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor ?? Colors.orange.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? defaultOrangeShade,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor ?? defaultOrangeShade,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}