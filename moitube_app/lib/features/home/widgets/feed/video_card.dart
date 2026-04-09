import 'package:flutter/material.dart';
import 'package:moitube_app/models/video.dart';
import 'package:moitube_app/features/home/screens/watch_video_screen.dart';
import 'package:moitube_app/features/home/screens/channel_detail_screen.dart';

class VideoCard extends StatelessWidget{
  final Video video;

  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    void openChannel() {
      final handle = (video.channelHandle ?? '').trim();
      final channelId = (video.channelId ?? '').trim();
      if (handle.isEmpty && channelId.isEmpty) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChannelDetailScreen(
            channelHandle: handle.isNotEmpty ? handle : null,
            channelId: channelId.isNotEmpty ? channelId : null,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WatchVideoScreen(videoId: video.id),
          ),
        );
      },
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Thumnail Video
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 16/9,
              child: Image.network(
                video.thumbnailUrl ?? 'https://via.placeholder.com/640x360.png?text=No+Thumbnail',
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
                  video.durationFormatted,
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
              InkWell(
                onTap: openChannel,
                borderRadius: BorderRadius.circular(20),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: const Color(0xffe24594),
                  backgroundImage: video.channelAvatarUrl != null
                      ? NetworkImage(video.channelAvatarUrl!)
                      : null,
                  child: video.channelAvatarUrl == null
                      ? Text(
                          video.channelName.isNotEmpty ? video.channelName[0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        )
                      : null,
                ),
              ),

              SizedBox(width: 10,),

              //Title VIdeo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
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
                        InkWell(
                          onTap: openChannel,
                          child: Text(
                            video.channelName,
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ),
                      ],
                    ),

                    //Views
                    Row(
                      children: [
                        Text(
                          '${video.viewsFormatted} lượt xem',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        Text(' • ' , style: TextStyle(color: Colors.white54, fontSize: 16)),
                        Text(
                          video.timeAgo,
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
      ),
    );
  }
}