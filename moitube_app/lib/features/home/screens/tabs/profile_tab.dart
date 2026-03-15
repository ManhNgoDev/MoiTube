import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/widgets/profile/profile_details.dart';
import 'package:moitube_app/features/home/widgets/profile/profile_header.dart';
import 'package:moitube_app/features/home/widgets/profile/profile_info.dart';
import 'package:moitube_app/features/home/widgets/profile/profile_stats.dart';


import 'package:moitube_app/features/home/controllers/channel_controller.dart';

import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
    const ProfileTab({super.key});

    @override
    State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChannelController>().fetchMyChannel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChannelController>();






    return Scaffold(
        backgroundColor: const Color(0xff000000),
        body: RefreshIndicator(
          onRefresh: () => controller.fetchMyChannel(),
          color: const Color(0xffe24594),
          child: CustomScrollView(
            slivers: [
              const ProfileHeader(),
  
              SliverToBoxAdapter(
                child: controller.myChannel == null 
                  ? Container(
                      height: 400,
                      alignment: Alignment.center,
                      child: controller.isLoading 
                        ? const CircularProgressIndicator(color: Color(0xffe24594))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, color: Colors.grey, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                controller.error ?? 'Không tìm thấy dữ liệu kênh',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              TextButton(
                                onPressed: () => controller.fetchMyChannel(),
                                child: const Text('Thử lại', style: TextStyle(color: Color(0xffe24594))),
                              ),
                            ],
                          ),
                    )
                  : Column(
                      children: const [
                        ProfileInfo(),
                        SizedBox(height: 24),
                        ProfileDetails(),
                        SizedBox(height: 24),
                        ProfileStats(),
                      ],
                    ),
              )
            ],
          ),
        ),
    );

  }
}