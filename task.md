# PROJECT: Video Social App – Sprint Watch / Upload / Comments

GOAL:
Deliver end-to-end core experience:
1) Watch video
2) Upload video
3) Comment system

AGENT GLOBAL RULES:
- Implement features in order: FEATURE_1 → FEATURE_2 → FEATURE_3
- Do not refactor unrelated code.
- Reuse existing models/services if available.
- After each feature: run app, fix compile/runtime errors.
- Small commits per task.
- Prefer simple UI over perfect UI.
- Avoid adding new packages unless listed below.

DEPENDENCIES (add if missing):
video_player
chewie
image_picker OR file_picker

---------------------------------------------------------------------

# FEATURE_1: WATCH VIDEO SCREEN (HIGHEST PRIORITY)

OBJECTIVE:
User taps a video → watch video → read info → browse related videos.

CREATE FILES:
screens/watch_video_screen.dart
widgets/video_player_widget.dart
widgets/related_video_list.dart
extend services/video_service.dart if needed

VIDEO MODEL REQUIRED:
id
title
description
videoUrl
thumbnailUrl
views
createdAt
authorName

API:
GET    /videos/{videoId}
POST   /videos/{videoId}/view
GET    /videos/{videoId}/related

TASKS:

1) Navigation
Home video item tap → push WatchVideoScreen(videoId)

2) Fetch video detail
On init:
Future<Video> videoFuture = getVideoDetail(videoId)

3) VideoPlayerWidget
Requirements:
- autoplay
- play/pause
- seek bar
- fullscreen
- dispose controller properly

4) Increase view count
On screen opened → call POST /videos/{videoId}/view (fire and forget)

5) Video info UI (below player)
Show:
- title
- authorName
- views
- createdAt
- description

6) Related videos
Fetch: GET /videos/{videoId}/related
Display vertical list:
thumbnail + title + views
Tap item → reload WatchVideoScreen(newVideoId)

WORKFLOW:
HomeFeed → tap video → WatchVideoScreen(videoId)
→ fetch video → init player → render info → load related

DONE WHEN:
- Video plays correctly
- Navigation to related video works
- No controller memory leak

---------------------------------------------------------------------

# FEATURE_2: UPLOAD VIDEO WORKFLOW

OBJECTIVE:
User selects video → enters info → uploads → video appears in feed.

EXISTING SCREENS (CONNECT THEM):
VideoDetailScreen
UploadingScreen
UploadSuccessScreen

CREATE FILE:
services/upload_service.dart

API:
POST /upload/video (multipart) → returns { videoUrl, thumbnailUrl }
POST /videos
body:
title
description
videoUrl
thumbnailUrl

FULL WORKFLOW:
UploadTab → PickVideo → VideoDetailScreen → UploadingScreen → UploadSuccessScreen → BackHome + refresh feed

TASKS:

1) Pick video from gallery
Use image_picker OR file_picker
Return File videoFile
If cancelled → stop flow

2) VideoDetailScreen inputs
Collect:
title (required)
description (optional)
privacy (optional)
Button: UPLOAD

3) UploadService implementation
Step 1: upload file (multipart) → get videoUrl + thumbnailUrl
Step 2: create video metadata via POST /videos

4) UploadingScreen
Show:
- upload progress %
- uploading state

On success → navigate UploadSuccessScreen

5) Refresh feed
After success:
popUntil(HomeScreen)
trigger feed reload

DONE WHEN:
- User uploads video successfully
- New video visible in feed
- No navigation crash

---------------------------------------------------------------------

# FEATURE_3: COMMENT SYSTEM

OBJECTIVE:
Users can read, post, delete comments under video.

CREATE FILES:
widgets/comment_section.dart
services/comment_service.dart
models/comment_model.dart

COMMENT MODEL:
id
userId
username
avatarUrl
content
createdAt

API:
POST   /comments          { videoId, content }
GET    /videos/{videoId}/comments
DELETE /comments/{commentId}

TASKS:

1) Load comments
Fetch when WatchVideoScreen opens.
Structure ready for pagination.

2) Comment UI (under video info)
Show:
- comment count
- input field + send button
- list of comments

3) Post comment
On send:
POST /comments
Append new comment locally (no full reload).

4) Delete comment
If comment.userId == currentUserId → show delete button
Call DELETE /comments/{commentId}
Remove locally.

WORKFLOW:
Open WatchVideoScreen → fetch comments → render list
User send → POST → append
User delete → DELETE → remove

DONE WHEN:
- Comments load correctly
- Can post comment instantly
- Can delete own comment

---------------------------------------------------------------------

# GLOBAL DEFINITION OF DONE

APP MUST SUPPORT:
- Watch video end-to-end
- Upload video end-to-end
- Comment end-to-end
- Smooth navigation
- No unused controllers
- No runtime crashes