import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class WebViewScreen extends StatelessWidget {
  final String title;
  final String url;

  const WebViewScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(title, style: AppTypography.labelLarge),
        backgroundColor: AppColors.darkText,
        centerTitle: true,
      ),
      // Requires webview_flutter package — placeholder until added
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.web, size: 48, color: AppColors.themeText),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                url,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.themeText,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'WebView will load here',
              style: AppTypography.caption,
            ),
          ],
        ),
      ),
    );
  }
}
