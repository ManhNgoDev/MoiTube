import 'package:flutter/material.dart';
import 'package:moitube_app/models/video.dart';

class ChannelRow extends StatelessWidget {
  final Video video;
  final VoidCallback? onSubscribe;
  final VoidCallback? onOpenChannel;
  final bool isSubscribed;
  final bool subscribing;

  const ChannelRow({
    super.key,
    required this.video,
    this.onSubscribe,
    this.onOpenChannel,
    this.isSubscribed = false,
    this.subscribing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          InkWell(
            onTap: onOpenChannel,
            borderRadius: BorderRadius.circular(22),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xffe24594),
              backgroundImage: video.channelAvatarUrl != null ? NetworkImage(video.channelAvatarUrl!) : null,
              child: video.channelAvatarUrl == null
                  ? Text(
                      video.channelName.isNotEmpty ? video.channelName[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: onOpenChannel,
              borderRadius: BorderRadius.circular(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.channelName,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${video.viewsFormatted} người đăng ký',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: subscribing ? null : onSubscribe,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSubscribed ? const Color(0xff303030) : const Color(0xffe24594),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                subscribing
                    ? '...'
                    : (isSubscribed ? 'Đã đăng ký' : 'Đăng ký'),
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

