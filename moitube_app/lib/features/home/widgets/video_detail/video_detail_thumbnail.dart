import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoDetailThumbnail extends StatefulWidget {
  final Function(String?) onImagePicked;

  const VideoDetailThumbnail({super.key, required this.onImagePicked});

  @override
  State<VideoDetailThumbnail> createState() => _VideoDetailThumbnailState();
}

class _VideoDetailThumbnailState extends State<VideoDetailThumbnail> {
  File? _imageFile;

  Future<void> _pickThumbnail() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickerFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickerFile != null) {
      setState(() {
        _imageFile = File(pickerFile.path);
      });
      widget.onImagePicked(pickerFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ảnh bìa', style: TextStyle(fontSize: 16, color: Colors.white)),

          SizedBox(height: 10),

          GestureDetector(
            onTap: _pickThumbnail,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white60, width: 1),
                color: Color(0xff18181B),
              ),
              clipBehavior: Clip.antiAlias,
              child: _imageFile != null
                  ? Stack(
                      children: [
                        Image.file(
                          _imageFile!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, color: Colors.white60, size: 60),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
