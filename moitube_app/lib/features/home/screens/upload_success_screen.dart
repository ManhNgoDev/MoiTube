import 'package:flutter/material.dart';

class UploadSuccessScreen extends StatelessWidget {
  const UploadSuccessScreen({super.key});

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
              
              // Success Icon Circle
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff10B981), // Green background
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white, 
                  size: 55,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Success Texts
              const Text(
                'Tải lên thành công!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Video của bạn đã được đăng tải và sẵn sàng để\nchia sẻ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Video Preview Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff18181B),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    // Thumbnail placeholder area
                    Container(
                      height: 160,
                      decoration: const BoxDecoration(
                        color: Color(0xff27272A),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.movie_creation_outlined,
                          color: Colors.white38,
                          size: 60,
                        ),
                      ),
                    ),
                    // Footer area
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: const BoxDecoration(
                        color: Color(0xff18181B),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: const Text(
                        '0 lượt xem • Vừa xong',
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Action Buttons
              // View on channel button
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: const LinearGradient(
                    colors: [Color(0xffE91E63), Color(0xFFA855F7)],
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to channel logic
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    'Xem trên kênh của tôi',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Upload another video button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff18181B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    // Pop back to upload screen (or tab)
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    'Tải video khác',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              
              const SizedBox(height: 15),
              
              // Back to home button
              TextButton(
                onPressed: () {
                  // Pop to home root
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text(
                  'Về trang chủ',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
