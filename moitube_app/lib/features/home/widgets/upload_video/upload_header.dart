import 'package:flutter/material.dart';

class UploadHeader extends StatelessWidget {
  const UploadHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white38, width: 0.5)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "Tạo nội dung",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
