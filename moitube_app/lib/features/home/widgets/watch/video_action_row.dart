import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/widgets/watch/watch_utils.dart';

class VideoActionRow extends StatelessWidget {
  final int likeCount;
  final bool liking;
  final bool disliking;
  final bool isLiked;
  final bool isDisliked;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onShare;
  final VoidCallback onDownload;

  const VideoActionRow({
    super.key,
    required this.likeCount,
    required this.liking,
    required this.disliking,
    required this.isLiked,
    required this.isDisliked,
    required this.onLike,
    required this.onDislike,
    required this.onShare,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Row(
        children: [
          _ActionChip(
            icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
            label: likeCount > 0 ? formatCountCompact(likeCount) : 'Thích',
            onTap: liking ? null : onLike,
            selected: isLiked,
          ),
          const SizedBox(width: 8),
          _ActionChip(
            icon: isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
            onTap: disliking ? null : onDislike,
            selected: isDisliked,
          ),
          const SizedBox(width: 8),
          _ActionChip(
            icon: Icons.share_outlined,
            label: 'Chia sẻ',
            onTap: onShare,
          ),
          const SizedBox(width: 8),
          _ActionChip(
            icon: Icons.download_outlined,
            label: 'Tải xuống',
            onTap: onDownload,
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback? onTap;
  final bool selected;

  const _ActionChip({
    required this.icon,
    this.label,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xffe24594) : const Color(0xff272727),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            if (label != null) ...[
              const SizedBox(width: 6),
              Text(
                label!,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

