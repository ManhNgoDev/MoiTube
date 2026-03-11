import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget{
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Color(0xff000000),
      elevation: 0,
      shape: Border(
        bottom: BorderSide(color: Colors.white60, width: 1)
      ),
      title: Text(
        'Trang Cá Nhân',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        //Icon Thông Báo
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        //Icon Chia Sẻ
        IconButton(
          icon: Icon(
            Icons.share,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        //Icon Cài Đặt
        IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        //Icon Đăng Xuất
        IconButton(
          icon: Icon(
            Icons.logout,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}