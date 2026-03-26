import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moitube_app/core/api_client.dart';
import 'package:moitube_app/features/home/screens/upload_success_screen.dart';

class UploadingScreen extends StatefulWidget {
  final String videoPath;
  final String? thumbnailPath;
  final String title;
  final String description;
  final String privacy;

  const UploadingScreen({
    super.key,
    required this.videoPath,
    this.thumbnailPath,
    required this.title,
    required this.description,
    required this.privacy,
  });

  @override
  State<UploadingScreen> createState() => _UploadingScreenState();
}

class _UploadingScreenState extends State<UploadingScreen> with SingleTickerProviderStateMixin {
  double _uploadProgress = 0.0;
  String _fileName = 'unknown.mp4';
  String _fileSize = '0.00 MB';
  bool _isError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getFileInfo();
    _startUpload();
  }

  void _getFileInfo() {
    try {
      final file = File(widget.videoPath);
      _fileName = widget.videoPath.split(Platform.pathSeparator).last;
      int bytes = file.lengthSync();
      _fileSize = '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } catch (e) {
      _fileName = widget.videoPath.split('/').last;
      _fileSize = 'Unknown Size';
    }
  }

  Future<void> _startUpload() async {
    try {
      final dio = ApiClient.dio;

      final Map<String, dynamic> dataMap = {
        'title': widget.title,
        'description': widget.description,
        'status': widget.privacy,
        'video': await MultipartFile.fromFile(
          widget.videoPath,
          filename: _fileName,
        ),
      };

      if (widget.thumbnailPath != null) {
        dataMap['thumbnail'] = await MultipartFile.fromFile(
          widget.thumbnailPath!,
          filename: widget.thumbnailPath!.split(Platform.pathSeparator).last,
        );
      }

      final formData = FormData.fromMap(dataMap);

      final response = await dio.post(
        '/videos',
        data: formData,
        onSendProgress: (sent, total) {
          if (total != -1) {
            setState(() {
              _uploadProgress = sent / total;
            });
          }
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const UploadSuccessScreen(),
            ),
          );
        }
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              
              // Upload Icon Circle
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff2A163B), // Dark purple background
                ),
                child: const Icon(
                  Icons.upload_rounded,
                  color: Color(0xffE91E63), // Pink upload icon
                  size: 50,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Uploading Texts
              const Text(
                'Đang tải lên...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Vui lòng không tắt trang này',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Progress Section
              if (!_isError) ...[
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Đang xử lý',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '${(_uploadProgress * 100).toInt()}%',
                          style: const TextStyle(
                            color: Color(0xffE91E63), // Pink text for percentage
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    
                    // Progress Bar
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          height: 6,
                          width: constraints.maxWidth,
                          decoration: BoxDecoration(
                            color: const Color(0xff2A2A2A),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 6,
                            width: constraints.maxWidth * _uploadProgress,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xffE91E63), // Pink start
                                  Color(0xFFA855F7), // Purple end
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ] else ...[
                // Error Section
                Column(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 40),
                    const SizedBox(height: 10),
                    const Text(
                      'Tải lên thất bại',
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _errorMessage ?? 'Đã có lỗi xảy ra',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff2A163B)),
                      onPressed: () {
                        setState(() {
                          _isError = false;
                          _uploadProgress = 0.0;
                        });
                        _startUpload();
                      },
                      child: const Text('Thử lại', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 25),
              
              // File Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xff18181B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.movie_creation_outlined,
                      color: Color(0xffE91E63),
                      size: 28,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _fileName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _fileSize,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
