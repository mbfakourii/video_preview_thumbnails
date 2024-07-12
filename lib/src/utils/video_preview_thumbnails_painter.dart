import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Crop vtt image base x y w h.
class VideoPreviewThumbnailsPainter extends CustomPainter {
  VideoPreviewThumbnailsPainter({
    required this.image,
    required this.sourceSize,
    required this.offsetX,
    required this.offsetY,
  });

  final ui.Image image;
  final Size sourceSize;
  final int offsetX;
  final int offsetY;

  @override
  void paint(final Canvas canvas, final Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(
        offsetX.toDouble(),
        offsetY.toDouble(),
        sourceSize.width,
        sourceSize.height,
      ),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(final VideoPreviewThumbnailsPainter oldDelegate) => true;
}
