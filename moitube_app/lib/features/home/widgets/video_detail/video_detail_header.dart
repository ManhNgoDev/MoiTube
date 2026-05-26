import 'package:flutter/material.dart';

class VideoDetailHeader extends StatelessWidget {
  final VoidCallback onUploadPressed;

  const VideoDetailHeader({super.key, required this.onUploadPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          Expanded(
            child: Center(
              child: Text(
                'Chi tiết video',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),

          SizedBox(
            width: 85,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: LinearGradient(
                  colors: [Color(0xFFA855F7), Color(0xFF3B82F6)],
                ),
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                ),
                onPressed: onUploadPressed,
                child: Text(
                  'Đăng',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
