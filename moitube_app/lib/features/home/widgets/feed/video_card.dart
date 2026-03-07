import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget{
  final Map<String, dynamic> video;

  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Thumnail Video
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 16/9,
              child: Image.network(
                video['thumbnail'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Color(0xff1a1a1a),
                  child: Icon(Icons.video_collection, color: Colors.white24, size: 48,),
                ),
              ),
            ),

            //Duration
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  video['duration'],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),

        //Info 
        Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Avatar
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xffdc3ab6),
                ),
                child: Center(
                  child: Text(
                    video['channel'][0].toUpperCase(),
                    style: TextStyle(
                      color: Color(0xffdc3ab6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10,),

              //Title VIdeo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 4,),

                    //Name Channel
                    Row(
                      children: [
                        Text(
                          video['channel'],
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),

                    //Views
                    Row(
                      children: [
                        Text(
                          '${video['views']} lượt xem',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        Text(' • ' , style: TextStyle(color: Colors.white54, fontSize: 16)),
                        Text(
                          video['time'],
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    )

                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}