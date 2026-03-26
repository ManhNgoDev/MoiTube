import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/widgets/upload_video/upload_body.dart';
import 'package:moitube_app/features/home/widgets/upload_video/upload_header.dart';

class UploadTab extends StatefulWidget {
  const UploadTab({super.key});

  @override
  State<UploadTab> createState() => _UploadTabState();
}

class _UploadTabState extends State<UploadTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000000),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Column(children: [UploadHeader(), UploadBody()]),
        ),
      ),
    );
  }
}
