import 'package:flutter/material.dart';

class VideoDescriptionSection extends StatelessWidget {
  final String description;
  final bool expanded;
  final VoidCallback onToggle;

  const VideoDescriptionSection({
    super.key,
    required this.description,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Mô tả',
                  style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Icon(
                  expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.white54,
                  size: 22,
                ),
              ],
            ),
            if (expanded && description.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                description,
                style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.6),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

