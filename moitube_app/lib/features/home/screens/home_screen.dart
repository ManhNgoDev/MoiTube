import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/screens/tabs/channel_tab.dart';
import 'package:moitube_app/features/home/screens/tabs/feed_tab.dart';
import 'package:moitube_app/features/home/screens/tabs/profile_tab.dart';
import 'package:moitube_app/features/home/screens/tabs/search_tab.dart';
import 'package:moitube_app/features/home/screens/tabs/upload_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currenIndex = 0;

  final List<Widget> _tabs = const [
    FeedTab(),
    SearchTab(),  
    UploadTab(),
    ChannelTab(),
    ProfileTab()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currenIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xff2a2a2a), width: 0.5)),
        ),

        child: BottomNavigationBar(
          currentIndex: _currenIndex,
          onTap: (index) => setState(() {
            _currenIndex = index;
          }),
          backgroundColor: Color(0xff0a0a0a),
          selectedItemColor: Color(0xffe24594),
          unselectedItemColor: Colors.white38,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Trang Chủ'
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Tìm kiếm',
            ),

            BottomNavigationBarItem(
              icon: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xffdd4c8e), Color(0xffad46ff), Color(0xffc84adf)]
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffdd4c8e),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(Icons.add),
              ),
              label: ''
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.video_collection_outlined),
              activeIcon: Icon(Icons.video_collection),
              label: 'Kênh',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              activeIcon: Icon(Icons.account_circle),
              label: 'Bạn'
            ),
          ],
        ),
      ),
    );
  }
}
