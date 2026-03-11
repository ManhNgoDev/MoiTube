import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/widgets/profile/profile_header.dart';

class ProfileTab extends StatefulWidget {
    const ProfileTab({super.key});

    @override
    State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff000000),
        body: CustomScrollView(
          slivers: [
            ProfileHeader()
          ],
        ),
    );
  }
}