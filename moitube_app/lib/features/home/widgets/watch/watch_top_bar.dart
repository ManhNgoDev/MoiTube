import 'package:flutter/material.dart';

class WatchTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback? onSettings;
  final VoidCallback? onMore;

  const WatchTopBar({
    super.key,
    required this.onBack,
    this.onSettings,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            onPressed: onBack,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
            onPressed: onSettings,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 22),
            onPressed: onMore,
          ),
        ],
      ),
    );
  }
}

