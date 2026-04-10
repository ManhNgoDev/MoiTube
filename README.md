# MoiTube - Premium Video Social Platform

MoiTube is a full-stack, visually rich video-sharing application built with a modern tech stack. It features a cross-platform mobile app (Flutter) with a premium Cyberpunk-inspired aesthetic and a highly scalable backend API (NestJS).

## 🎨 Development Approach

This project was developed using the **"Vibe Coding"** philosophy — a seamless blend of human creativity and AI-driven implementation (powered by Antigravity). Instead of traditional, rigid development cycles, the focus was on rapid iteration, intuitive feature building, and maintaining a high-energy development "vibe" to bring a complex product to life in record time.

## 🚀 Overview

MoiTube allows users to upload, watch, and interact with videos. It includes a robust notification system, subscription-based feeds, history tracking, and a comprehensive comment system, all wrapped in a top-tier user interface.

## 🛠 Tech Stack

### Backend
- **Framework**: [NestJS](https://nestjs.com/)
- **Database**: [PostgreSQL](https://www.postgresql.org/) with [TypeORM](https://typeorm.io/)
- **Authentication**: JWT (JSON Web Tokens) with Refresh Token flow
- **Storage**: [Cloudinary](https://cloudinary.com/) for video and image hosting
- **Email/OTP**: Nodemailer for account verification and password recovery
- **Validation**: Class-validator & Class-transformer

### Mobile App
- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **HTTP Client**: [Dio](https://pub.dev/packages/dio)
- **Video Player**: [Chewie](https://pub.dev/packages/chewie) & [video_player](https://pub.dev/packages/video_player)
- **Animations & Design**: Radial Gradients, Safe Margins, Lottie

## ✨ Core Features

- **Authentication & Security**: 
  - Secure login/register with OTP email verification. 
  - Advanced **Forgot Password / Password Recovery** flow utilizing real-time 6-digit OTP delivery through Gmail.
- **Video Management**:
  - High-quality video uploading to Cloudinary.
  - Automatic thumbnail generation/hosting.
  - Interactive player with seek, volume, and fullscreen support.
  - View counting and Like/Dislike reaction system.
- **Enhanced User Experience**:
  - **Watch History Tracker**: YouTube-style viewing history that automatically tracks watched videos and leverages a smart backend "upsert" cache to prevent database bloat, paired with swipe-to-delete UI capabilities.
  - Fast Video Search by title with Binary Search implementation and recent keyword history.
- **Social Interaction**:
  - Real-time notification triggers for likes on videos, comments, and new channel uploads.
  - Nested comment system for deep discussions.
  - Channel subscriptions and personalized "Subscription Feeds".
- **Profile**: Customizable user profiles and unique channel handles.

## 📂 Project Structure

```text
MoiTube/
├── backend/          # NestJS API Root
├── moitube_app/      # Flutter Mobile App Workspace
└── README.md         # Documentation
```

## ⚙️ Getting Started

### Backend Setup
1. Navigate to `/backend`.
2. Install dependencies: `npm install`.
3. Copy `.env.example` to `.env` and fill in your credentials (Database URL, Cloudinary, Gmail App Password).
4. Start the server: `npm run start:dev`.

### Mobile App Setup
1. Navigate to `/moitube_app`.
2. Install dependencies: `flutter pub get`.
3. Update `lib/core/api_client.dart` with your local IP or production Backend URL.
4. Run the app on emulator or real device: `flutter run`.

## 🛡 License
This project is UNLICENSED.
