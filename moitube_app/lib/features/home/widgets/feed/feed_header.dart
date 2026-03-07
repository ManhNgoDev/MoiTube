import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/data/categories_data.dart';
import 'package:moitube_app/features/home/widgets/feed/category_filter.dart';

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
      backgroundColor: Color(0xff000000),
      elevation: 0,
      title: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0xffdc3ab6), Color(0xffaf2fe2)],
            ).createShader(bounds),
            child: Text(
              'MoiTube',
              style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.cast_outlined, color: Colors.white),
          onPressed: () {},
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xffdc3ab6),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: CategoryFilter(
          selectedIndex: selectedCategory,
          onChanged: onCategoryChanged,
          categories: categories,
        ),
      ),
    );
  }
}
