import 'dart:io';
import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/models/channel_model.dart';

class EditProfileImages extends StatelessWidget {
  final ChannelModel? channel;
  final File? avatarFile;
  final File? bannerFile;
  final VoidCallback onPickAvatar;
  final VoidCallback onPickBanner;

  const EditProfileImages({
    super.key,
    this.channel,
    this.avatarFile,
    this.bannerFile,
    required this.onPickAvatar,
    required this.onPickBanner,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          // Banner Image
          GestureDetector(
            onTap: onPickBanner,
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                gradient: bannerFile == null && channel?.bannerUrl == null
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                      )
                    : null,
                image: bannerFile != null
                    ? DecorationImage(
                        image: FileImage(bannerFile!),
                        fit: BoxFit.cover,
                      )
                    : (channel?.bannerUrl != null
                        ? DecorationImage(
                            image: NetworkImage(channel!.bannerUrl!),
                            fit: BoxFit.cover,
                          )
                        : null),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
          // Avatar Image
          Positioned(
            bottom: 0,
            left: 20,
            child: GestureDetector(
              onTap: onPickAvatar,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey[900],
                      backgroundImage: avatarFile != null
                          ? FileImage(avatarFile!)
                          : (channel?.avatarUrl != null
                              ? NetworkImage(channel!.avatarUrl!)
                              : null),
                      child: (avatarFile == null && channel?.avatarUrl == null)
                          ? const Icon(Icons.person, size: 45, color: Colors.grey)
                          : null,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFBD37D1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
