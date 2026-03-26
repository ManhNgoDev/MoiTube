import 'package:flutter/material.dart';

class VideoDetailPrivacy extends StatefulWidget {
  final Function(String) onPrivacyChanged;

  const VideoDetailPrivacy({super.key, required this.onPrivacyChanged});

  @override
  State<VideoDetailPrivacy> createState() => _VideoDetailPrivacyState();
}

class _VideoDetailPrivacyState extends State<VideoDetailPrivacy> {
  String selectedPrivacy = 'public';

  void _handleOptionChanged(String value) {
    setState(() {
      selectedPrivacy = value;
    });
    widget.onPrivacyChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.visibility_outlined, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Quyền riêng tư',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 15),
          _buildPrivacyOption(
            value: 'public',
            title: 'Công khai',
            subtitle: 'Mọi người đều có thể xem',
            icon: Icons.public,
          ),
          SizedBox(height: 10),
          _buildPrivacyOption(
            value: 'unlisted',
            title: 'Không công khai',
            subtitle: 'Chỉ người có link mới xem được',
            icon: Icons.people_outline,
          ),
          SizedBox(height: 10),
          _buildPrivacyOption(
            value: 'private',
            title: 'Riêng tư',
            subtitle: 'Chỉ mình bạn xem được',
            icon: Icons.lock_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    bool isSelected = selectedPrivacy == value;
    Color activeColor = Color(0xFFA855F7); // matching the pink/purple from image
    Color inactiveColor = Color(0xff18181B);

    return GestureDetector(
      onTap: () => _handleOptionChanged(value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withAlpha(25) : inactiveColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : Colors.white60,
              size: 28,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_outline,
                color: activeColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
