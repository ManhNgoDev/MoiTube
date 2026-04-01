import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _hasError = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    if (widget.videoUrl.isEmpty) {
      if (mounted) setState(() { _hasError = true; _isInitializing = false; });
      return;
    }

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    );

    try {
      await _videoController.initialize().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Video load timeout');
        },
      );

      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoController.value.aspectRatio,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xffe24594),
          handleColor: const Color(0xffe24594),
          bufferedColor: Colors.white24,
          backgroundColor: Colors.white12,
        ),
        errorBuilder: (context, errorMessage) {
          return _buildErrorWidget();
        },
      );
      if (mounted) setState(() => _isInitializing = false);
    } catch (e) {
      debugPrint('Video player error: $e');
      if (mounted) setState(() { _hasError = true; _isInitializing = false; });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  Widget _buildErrorWidget() {
    return Container(
      color: const Color(0xff1a1a1a),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam_off_outlined, color: Colors.white38, size: 40),
            const SizedBox(height: 8),
            const Text('Không thể phát video', style: TextStyle(color: Colors.white54, fontSize: 13)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() { _hasError = false; _isInitializing = true; });
                _initPlayer();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xff272727),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('Thử lại', style: TextStyle(color: Color(0xffe24594), fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return AspectRatio(aspectRatio: 16 / 9, child: _buildErrorWidget());
    }

    if (_isInitializing || _chewieController == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xffe24594)),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _videoController.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }
}
