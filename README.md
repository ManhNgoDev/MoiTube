# MoiTube - Video Social Platform

MoiTube is a full-stack video-sharing application built with a modern tech stack. It features a cross-platform mobile app (Flutter) and a scalable backend API (NestJS).

## 🎨 Development Approach

This project was developed using the **"Vibe Coding"** philosophy — a seamless blend of human creativity and AI-driven implementation (powered by Antigravity). Instead of traditional, rigid development cycles, the focus was on rapid iteration, intuitive feature building, and maintaining a high-energy development "vibe" to bring a complex product to life in record time.


## 🚀 Overview

MoiTube allows users to upload, watch, and interact with videos. It includes a robust notification system, subscription-based feeds, and a comprehensive comment system.

## 🛠 Tech Stack

### Backend
- **Framework**: [NestJS](https://nestjs.com/)
- **Database**: [PostgreSQL](https://www.postgresql.org/) with [TypeORM](https://typeorm.io/)
- **Authentication**: JWT (JSON Web Tokens) with Refresh Token flow
- **Storage**: [Cloudinary](https://cloudinary.com/) for video and image hosting
- **Email**: Nodemailer for account verification
- **Validation**: Class-validator & Class-transformer

### Mobile App
- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **HTTP Client**: [Dio](https://pub.dev/packages/dio)
- **Video Player**: [Chewie](https://pub.dev/packages/chewie) & [video_player](https://pub.dev/packages/video_player)
- **Animations**: [Lottie](https://pub.dev/packages/lottie)

## ✨ Features

- **Authentication**: Secure login/register with email verification.
- **Video Management**:
  - High-quality video uploading to Cloudinary.
  - Automatic thumbnail generation/hosting.
  - Interactive player with seek, volume, and fullscreen support.
  - View counting and Like/Dislike system.
- **Social Interaction**:
  - Real-time (simulated) notification system for likes and new uploads.
  - Nested comment system.
  - Channel subscriptions and personalized "Subscription Feed".
- **Search**: Fast video search by title and description.
- **Profile**: Customizable user profiles and channel handles.

## 📂 Project Structure

```text
MoiTube/
├── backend/          # NestJS API
├── moitube_app/      # Flutter Mobile App
└── task.md           # Project Roadmap & Features
```

## ⚙️ Getting Started

### Backend Setup
1. Navigate to `/backend`.
2. Install dependencies: `npm install`.
3. Copy `.env.example` to `.env` and fill in your credentials (Database, Cloudinary, Gmail).
4. Start the server: `npm run start:dev`.

### Mobile App Setup
1. Navigate to `/moitube_app`.
2. Install dependencies: `flutter pub get`.
3. Update `lib/core/api_client.dart` with your local IP / Backend URL.
4. Run the app: `flutter run`.

## 🛡 License
This project is UNLICENSED.
