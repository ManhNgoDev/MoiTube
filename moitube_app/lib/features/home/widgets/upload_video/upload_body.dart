import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:moitube_app/features/home/screens/video_detail.dart';

class UploadBody extends StatelessWidget {
  const UploadBody({super.key});

  Future<void> uploadVideo(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result != null) {
      String path = result.files.single.path!;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideoDetail(videoPath: path)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 150),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff201133),
            ),
            child: Icon(
              Icons.local_movies_outlined,
              color: Colors.purpleAccent,
              size: 50,
            ),
          ),

          SizedBox(height: 20),

          Text(
            'Chọn video để tải lên',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),

          SizedBox(height: 25),

          SizedBox(
            width: 150,
            height: 55,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFA855F7), Color(0xFF3B82F6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                ),
                icon: Icon(Icons.upload, color: Colors.white, size: 20),
                label: Text(
                  'Chọn file',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: () => uploadVideo(context),
              ),
            ),
          ),

          SizedBox(height: 50),

          Text(
            'Chỉ hỗ trợ video có thời lượng từ 15 phút trở xuống',
            style: TextStyle(color: Colors.white60, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
