import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/widgets/video_detail/video_detail_form.dart';
import 'package:moitube_app/features/home/widgets/video_detail/video_detail_header.dart';
import 'package:moitube_app/features/home/widgets/video_detail/video_detail_preview_vid.dart';
import 'package:moitube_app/features/home/widgets/video_detail/video_detail_thumbnail.dart';
import 'package:moitube_app/features/home/widgets/video_detail/video_detail_privacy.dart';
import 'package:moitube_app/features/home/screens/uploading_screen.dart';
class VideoDetail extends StatefulWidget {
  final String videoPath;

  const VideoDetail({super.key, required this.videoPath});

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedPrivacy = 'public';
  String? _thumbnailPath;

  @override
  void dispose() {
    _scrollController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            VideoDetailHeader(
              onUploadPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UploadingScreen(
                      videoPath: widget.videoPath,
                      thumbnailPath: _thumbnailPath,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      privacy: _selectedPrivacy,
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 10),

            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VideoDetailPreviewvid(videoPath: widget.videoPath),

                      SizedBox(height: 20),

                      VideoDetailForm(
                        titleController: _titleController,
                        descriptionController: _descriptionController,
                      ),

                      SizedBox(height: 15),

                      VideoDetailPrivacy(
                        onPrivacyChanged: (val) {
                          setState(() {
                            _selectedPrivacy = val;
                          });
                        },
                      ),

                      SizedBox(height: 15),

                      VideoDetailThumbnail(
                        onImagePicked: (path) {
                          setState(() {
                            _thumbnailPath = path;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
