import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/data/mock_videos.dart';
import 'package:moitube_app/features/home/widgets/feed/feed_header.dart';
import 'package:moitube_app/features/home/widgets/feed/video_card.dart';


class FeedTab extends StatefulWidget {
    const FeedTab({super.key});

    @override
    State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
    int _selectedCategory = 0;
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: CustomScrollView(
        slivers: [
          FeedHeader(
            selectedCategory: _selectedCategory,
            onCategoryChanged: (index) => setState(() => _selectedCategory = index),
          ),
          
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => VideoCard(
                video: mockVideos[index % mockVideos.length],
              ),
              childCount: 20
            ),
          )
        ],
      ),
    );
  }
}