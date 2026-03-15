import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/controllers/channel_controller.dart';
import 'package:provider/provider.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final channel = context.watch<ChannelController>().myChannel;

    if (channel == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Header Section: Cover and Profile Image
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Cover Image
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: channel.bannerUrl == null 
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // Premium Purple Gradient
                    )
                  : null,
                image: channel.bannerUrl != null 
                  ? DecorationImage(
                      image: NetworkImage(channel.bannerUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),

            // Profile Image
            Positioned(
              bottom: -50,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[900],
                      backgroundImage: channel.avatarUrl != null 
                        ? NetworkImage(channel.avatarUrl!)
                        : null,
                      child: channel.avatarUrl == null 
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFBD37D1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.trending_up,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 60),

        // Name Section with Gradient
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFF40B4), Color(0xFF4080FF)],
          ).createShader(bounds),
          child: Text(
            channel.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        Text(
          '@${channel.handle}',
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),

        const SizedBox(height: 16),

        // Bio Section
        if (channel.description != null && channel.description!.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description_outlined, color: Colors.grey[400], size: 18),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  channel.description!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}