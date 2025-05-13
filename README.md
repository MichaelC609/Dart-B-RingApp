# Smart Doorbell Security System

A mobile-first smart doorbell system built with Flutter, Raspberry Pi, and AWS. The app enables real-time video streaming, motion-triggered alerts, and downloadable video clips from a rolling 15-minute buffer.

## Features

- 📹 **Live Video Streaming**  
  Streams real-time footage from a Raspberry Pi camera to the mobile app using an RTMP server hosted on AWS EC2.

- 🎥 **Rolling Video Buffer + Clip Download**  
  Maintains a continuous 15-minute video buffer using FFmpeg and cron jobs. Users can request and download clips via the mobile app through HTTP GET requests handled by a Flask server.

- 🔔 **Motion Detection & Notifications**  
  Motion events trigger AWS Lambda functions through API Gateway, which send notifications via Flask routes hosted on EC2.

## Architecture


![NotificationSystemDiagram](https://github.com/user-attachments/assets/853ff174-f452-4df8-adec-8463737612a1)




## Technologies Used

- **Frontend:** Flutter, Dart  
- **Backend:** Python (Flask), FFmpeg, cron  
- **Streaming:** RTMP (Nginx RTMP Module)  
- **Cloud Infrastructure:** AWS EC2, AWS Lambda, API Gateway  
- **Hardware:** Raspberry Pi Zero 2 W + Camera Module

## How It Works

1. **Streaming:**  
   The Raspberry Pi streams video to an Nginx RTMP server running on EC2.

2. **Rolling Buffer:**  
   FFmpeg segments the stream into 1-second `.ts` files stored in shared memory. A cron job maintains only the most recent 15 minutes of footage.

3. **Clip Request:**  
   Users enter a duration in the Flutter app. The app sends an HTTP GET request to the Flask server, which assembles and returns a video clip in MP4 or ZIP format.

4. **Motion Alerts:**  
   Motion detection triggers a Lambda function via API Gateway. The function invokes the Flask API to notify the mobile app of motion events.

## Setup Instructions

> These are high-level steps. Adjust IP addresses, paths, and credentials as needed.

### 📦 Raspberry Pi

1. Enable the camera module and run:
   ```bash
   libcamera-vid -t 0 --inline --width 640 --height 480 --framerate 25 -o - | \
   ffmpeg -re -f h264 -i - -vcodec copy -an -f flv rtmp://<EC2-IP>/live/doorbell

## 🔧 AWS EC2 Setup
Configure Nginx with the RTMP module
Compile from source if needed to enable RTMP support.

Set up and run the Flask web server to handle:
Video clip download requests

Motion alert endpoints

Start the FFmpeg segmenter to write 1-second .ts files to a shared memory directory:
```bash
ffmpeg -i rtmp://localhost/live/doorbell -c:v libx264 -f segment -segment_time 1 \
-reset_timestamps 1 -strftime 1 /dev/shm/rolling/segment-%Y%m%d-%H%M%S.ts
```

### Install required packages:
```bash
sudo apt update
sudo apt install nginx ffmpeg python3 python3-pip
pip3 install flask
```


## ⏱️ Cron Job for Rolling Buffer
Create a script that calculates the total duration of .ts files in /path/to/stored/clips and deletes the oldest files until the total duration is under 15 minutes.

Add this to your crontab:

```bash
* * * * * /usr/bin/python3 /path/to/cleanup/script.py
```


## 📱 Flutter App Setup
Install dependencies:
dependencies:
  flutter:
    sdk: flutter
  flutter_vlc_player: ^latest
  http: ^latest
  path_provider: ^latest
  gallery_saver_plus: ^latest
```bash
flutter pub get
```
  
### Configure:
- RTMP stream URL (for VLC player)
- Clip request endpoint (Flask server on EC2)

Build and run:
```bash
flutter run
```



