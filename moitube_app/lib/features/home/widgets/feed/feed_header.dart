import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/controllers/notification_controller.dart';
import 'package:moitube_app/features/home/screens/notification_screen.dart';
import 'package:provider/provider.dart';

class FeedHeader extends StatelessWidget {
  final int selectedCategory;
  final Function(int) onCategoryChanged;

  const FeedHeader({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: const Color(0xff000000),
      elevation: 0,
      title: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xffdc3ab6), Color(0xffaf2fe2)],
            ).createShader(bounds),
            child: const Text(
              'MoiTube',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.cast_outlined, color: Colors.white),
          onPressed: () {},
        ),
        Consumer<NotificationController>(
          builder: (context, controller, child) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                ),
                if (controller.unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xffdc3ab6),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          controller.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],

      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(48),
      //   child: CategoryFilter(
      //     selectedIndex: selectedCategory,
      //     onChanged: onCategoryChanged,
      //     categories: categories,
      //   ),
      // ),
    );
  }
}
