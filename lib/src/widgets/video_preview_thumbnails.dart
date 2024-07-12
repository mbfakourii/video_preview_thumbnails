import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_preview_thumbnails/video_preview_thumbnails.dart';

class VideoPreviewThumbnails extends StatefulWidget {
  const VideoPreviewThumbnails({
    required this.vtt,
    required this.controller,
    super.key,
    this.loading,
    this.error,
    this.baseUrlVttImages,
    this.scale = 1.0,
  });

  final VideoPreviewThumbnailsController controller;
  final Uint8List vtt;
  final Widget? loading;
  final Widget? error;
  final String? baseUrlVttImages;
  final double scale;

  @override
  State<VideoPreviewThumbnails> createState() => _VideoPreviewThumbnailsState();
}

class _VideoPreviewThumbnailsState extends State<VideoPreviewThumbnails> {
  final List<VttDataModel> images = <VttDataModel>[];
  VttDataModel currentVttData = VttDataModel.empty;
  late VttDataController vttDataController;
  final Dio dio = Dio();

  ui.Image? thumbnailsImage;

  @override
  void initState() {
    final String vttData = String.fromCharCodes(widget.vtt);
    vttDataController = VttDataController.string(vttData);
    currentVttData = vttDataController.vttDataFromMilliseconds(0);

    _getThumbnailImage(vttDataController.vttData.first.imageUrl);

    widget.controller.addListener(
      () {
        setState(() {
          currentVttData = vttDataController.vttDataFromMilliseconds(
            widget.controller.getCurrentTime(),
          );
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(final BuildContext context) => (thumbnailsImage != null)
      ? CustomPaint(
          painter: VideoPreviewThumbnailsPainter(
            image: thumbnailsImage!,
            sourceSize: Size(
              currentVttData.w.toDouble(),
              currentVttData.h.toDouble(),
            ),
            offsetX: currentVttData.x,
            offsetY: currentVttData.y,
          ),
          size: Size(
                currentVttData.w.toDouble(),
                currentVttData.h.toDouble(),
              ) *
              widget.scale,
        )
      : const SizedBox.shrink();

  Future<void> _getThumbnailImage(final String url) async {
    // get image
    final Response<List<int>> response = await dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    // Convert to ui image
    try {
      thumbnailsImage = await loadImage(
        Uint8List.fromList(response.data!),
      );
    } catch (_) {}

    setState(() {});
  }

  Future<ui.Image> loadImage(final Uint8List img) async {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    ui.decodeImageFromList(img, completer.complete);
    return completer.future;
  }
}
