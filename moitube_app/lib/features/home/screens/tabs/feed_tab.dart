import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moitube_app/features/home/controllers/video_controller.dart';
import 'package:moitube_app/features/home/widgets/feed/feed_header.dart';
import 'package:moitube_app/features/home/widgets/feed/video_card.dart';


class FeedTab extends StatefulWidget {
    const FeedTab({super.key});

    @override
    State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  int _selectedCategory = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoController>().fetchVideos(refresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<VideoController>().fetchVideos();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: RefreshIndicator(
        onRefresh: () => context.read<VideoController>().fetchVideos(refresh: true),
        color: const Color(0xffe24594),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            FeedHeader(
              selectedCategory: _selectedCategory,
              onCategoryChanged: (index) => setState(() => _selectedCategory = index),
            ),
            
            Consumer<VideoController>(
              builder: (context, videoController, child) {
                if (videoController.isLoading && videoController.videos.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator(color: Color(0xffe24594))),
                  );
                }

                if (videoController.error != null && videoController.videos.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Đã có lỗi xảy ra', style: TextStyle(color: Colors.white)),
                          TextButton(
                            onPressed: () => videoController.fetchVideos(refresh: true),
                            child: Text('Thử lại', style: TextStyle(color: Color(0xffe24594))),
                          )
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == videoController.videos.length) {
                        return videoController.hasMore 
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator(color: Color(0xffe24594))),
                            )
                          : const SizedBox();
                      }
                      return VideoCard(video: videoController.videos[index]);
                    },
                    childCount: videoController.videos.length + (videoController.hasMore ? 1 : 0),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}