import 'package:flutter/material.dart';

class UploadTab extends StatefulWidget {
    const UploadTab({super.key});

    @override
    State<UploadTab> createState() => _UploadTabState();
}

class _UploadTabState extends State<UploadTab> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text('Upload'),
    );
  }
}