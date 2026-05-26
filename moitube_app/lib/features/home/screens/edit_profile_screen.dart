import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moitube_app/features/home/controllers/channel_controller.dart';
import 'package:provider/provider.dart';

import '../widgets/edit_profile/edit_profile_images.dart';
import '../widgets/edit_profile/edit_social_links.dart';
import '../widgets/edit_profile/info_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _handleController;
  late TextEditingController _descriptionController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;

  final List<SocialLinkItem> _socialLinks = [];

  File? _avatarFile;
  File? _bannerFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final channel = context.read<ChannelController>().myChannel;

    _nameController = TextEditingController(text: channel?.name ?? '');
    _handleController = TextEditingController(text: channel?.handle ?? '');
    _descriptionController = TextEditingController(
      text: channel?.description ?? '',
    );
    _emailController = TextEditingController(text: '');
    _locationController = TextEditingController(text: '');

    if (channel?.socialLinks != null) {
      channel!.socialLinks!.forEach((key, value) {
        _socialLinks.add(SocialLinkItem(type: key, url: value.toString()));
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    _descriptionController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isAvatar) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isAvatar) {
          _avatarFile = File(image.path);
        } else {
          _bannerFile = File(image.path);
        }
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> updateData = {
        'name': _nameController.text,
        'handle': _handleController.text.replaceAll('@', ''), // strip @ if added by user
        'description': _descriptionController.text,
      };

      final websiteUrl = _socialLinks
          .firstWhere(
            (e) => e.type == 'Website',
            orElse: () => SocialLinkItem(type: 'Website', url: ''),
          )
          .url;
      
      if (websiteUrl.isNotEmpty) {
        updateData['website_url'] = websiteUrl;
      }

      final socialMap = {
        for (var e in _socialLinks)
          if (e.url.isNotEmpty && e.type != 'Website') e.type: e.url,
      };

      if (socialMap.isNotEmpty) {
        updateData['social_links'] = socialMap;
      }

      final success = await context.read<ChannelController>().updateChannelInfo(
        updateData,
        avatar: _avatarFile,
        banner: _bannerFile,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật profile thành công!')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        final error = context.read<ChannelController>().error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Có lỗi xảy ra, vui lòng thử lại'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final channel = context.watch<ChannelController>().myChannel;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Chỉnh sửa Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Lưu',
              style: TextStyle(
                color: Color(0xFFBD37D1),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditProfileImages(
                channel: channel,
                avatarFile: _avatarFile,
                bannerFile: _bannerFile,
                onPickAvatar: () => _pickImage(true),
                onPickBanner: () => _pickImage(false),
              ),

              const SizedBox(height: 32),

              const Text(
                'Thông tin cơ bản',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              InfoField(label: 'Tên kênh', controller: _nameController, hint: 'Nhập tên kênh', isRequired: true),
              const SizedBox(height: 20),
              InfoField(
                label: 'Handle', 
                controller: _handleController, 
                hint: '@handle',
                subLabel: 'Handle của bạn là địa chỉ duy nhất trên MoiTube',
                isRequired: true,
              ),
              const SizedBox(height: 24),
              InfoField(
                label: 'Mô tả kênh',
                controller: _descriptionController,
                hint: 'Mô tả kênh của bạn...',
                maxLines: 4,
                maxLength: 1000,
                subLabel: 'Mô tả chi tiết sẽ giúp người xem hiểu rõ hơn về kênh',
              ),

              const SizedBox(height: 40),

              const Text(
                'Thông tin liên hệ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              InfoField(label: 'Email', controller: _emailController, hint: 'contact@example.com'),
              const SizedBox(height: 20),
              InfoField(label: 'Vị trí', controller: _locationController, hint: 'Hà Nội, Việt Nam'),

              const SizedBox(height: 40),

              EditSocialLinks(
                socialLinks: _socialLinks,
                onAddLink: () => setState(() => _socialLinks.add(SocialLinkItem(type: 'Website', url: ''))),
                onRemoveLink: (index) => setState(() => _socialLinks.removeAt(index)),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialLinkItem {
  String type;
  String url;
  SocialLinkItem({required this.type, required this.url});
}

