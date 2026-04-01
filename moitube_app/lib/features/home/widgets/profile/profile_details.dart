import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/controllers/channel_controller.dart';
import 'package:provider/provider.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final channel = context.watch<ChannelController>().myChannel;

    if (channel == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Stats Row (Join date and Videos count)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, color: Colors.grey[600], size: 16),
            const SizedBox(width: 4),
            Text(
              'Tham gia từ ${_formatDate(channel.createdAt)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(width: 12),
            Icon(Icons.upload_outlined, color: Colors.grey[600], size: 18),
            const SizedBox(width: 4),
            Text(
              '${channel.videoCount} videos',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Links Section
        if (channel.websiteUrl != null && channel.websiteUrl!.isNotEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[900]!),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.link, color: Color(0xFFFF40B4), size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Liên kết',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildLinkRow('Website', channel.websiteUrl!),
              ],
            ),
          ),

        const SizedBox(height: 32),

        // Action Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/edit-profile'),
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF3CAC), Color(0xFFBD37D1)],
                      ),
                      borderRadius: BorderRadius.circular(27),
                    ),
                    child: Center(
                      child: const Text(
                        'Chỉnh Sửa Kênh',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),
              Container(
                height: 54,
                width: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF262626),
                  borderRadius: BorderRadius.circular(27),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Chia Sẻ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildLinkRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

