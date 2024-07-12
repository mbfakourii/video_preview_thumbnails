![logo](https://github.com/user-attachments/assets/de47507d-1660-4977-850a-dd671882ee40)

# Video Preview Thumbnails

[![pub package](https://img.shields.io/pub/v/video_preview_thumbnails.svg)](https://pub.dev/packages/video_preview_thumbnails)</br>
Video preview thumbnails base vtt file

## Example App
<img src="https://raw.githubusercontent.com/mbfakourii/video_preview_thumbnails/master/example/screenshots/example.gif" width="300" height="550" />

## Usage

Quick simple usage example:

```dart
VideoPreviewThumbnailsController controller = VideoPreviewThumbnailsController();
Uint8List vttFile=...;

VideoPreviewThumbnails(
    vtt: vttFile!,
    controller: controller,
)

controller.setCurrentTime(1500);
```

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view
the [documentation](https://flutter.io/platform-plugins/#edit-code).
