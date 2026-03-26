import 'package:flutter/material.dart';

class VideoDetailForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const VideoDetailForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tiêu đề *',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),

            SizedBox(height: 10),

            TextField(
              controller: titleController,
              maxLength: 100,
              style: TextStyle(fontSize: 18, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xff18181B),

                hintText: 'Nhập tiêu đề hấp dẫn cho video của bạn',
                hintStyle: TextStyle(color: Colors.white60),

                counterStyle: TextStyle(fontSize: 15),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white60, width: 1),
                ),
              ),
            ),

            Text('Mô tả', style: TextStyle(color: Colors.white, fontSize: 16)),

            SizedBox(height: 10),

            TextField(
              controller: descriptionController,
              maxLength: 1000,
              style: TextStyle(fontSize: 18, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xff18181B),

                hintText: 'Nhập mô tả cho video của bạn',
                hintStyle: TextStyle(color: Colors.white60),

                counterStyle: TextStyle(fontSize: 15),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white60, width: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
