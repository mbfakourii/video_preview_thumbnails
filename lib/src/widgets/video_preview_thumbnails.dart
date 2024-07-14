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
    this.empty,
    this.baseUrlVttImages = '',
    this.scale = 1.0,
  });

  /// The controller responsible for managing and controlling the VideoPreviewThumbnails.
  final VideoPreviewThumbnailsController controller;

  /// The raw data (binary) of the VTT file containing the information for the preview images.
  final Uint8List vtt;

  /// The widget to display while the previews are loading.
  ///
  /// If this widget is not provided, a default loading indicator will be displayed.
  final Widget? loading;

  /// The widget to display if there is an error loading the previews.
  ///
  /// If this widget is not provided, a default error indicator will be displayed.
  final Widget? error;

  /// The widget to display if there are no preview images available.
  ///
  /// If this widget is not provided, a default empty indicator will be displayed.
  final Widget? empty;

  /// The base URL for the VTT images.
  ///
  /// This is used to construct the full URLs for the preview images.
  final String baseUrlVttImages;

  /// The scale factor for the preview images.
  final double scale;

  @override
  State<VideoPreviewThumbnails> createState() => _VideoPreviewThumbnailsState();
}

class _VideoPreviewThumbnailsState extends State<VideoPreviewThumbnails> {
  VttDataModel currentVttData = VttDataModel.empty;
  late VttDataController vttDataController;
  final Dio dio = Dio();

  ui.Image? thumbnailsImage;
  bool hasError = false;
  bool isLoading = true;

  @override
  void initState() {
    final String vttData = String.fromCharCodes(widget.vtt);
    vttDataController = VttDataController.string(vttData);
    currentVttData = vttDataController.vttDataFromMilliseconds(0);

    _getThumbnailImage(vttDataController.vttData.first.imageUrl);

    widget.controller.addListener(
      () {
        if (mounted) {
          setState(() {
            currentVttData = vttDataController.vttDataFromMilliseconds(
              widget.controller.getCurrentTime(),
            );
          });
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(final BuildContext context) => hasError
      ? widget.error ??
          const Center(
            child: Icon(
              Icons.error,
            ),
          )
      : isLoading
          ? widget.loading ??
              const Center(
                child: CircularProgressIndicator(),
              )
          : (thumbnailsImage != null)
              ? Stack(
                  children: <Widget>[
                    SizedBox.expand(
                      child: widget.empty ??
                          Container(
                            color: Colors.black,
                          ),
                    ),
                    CustomPaint(
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
                    ),
                  ],
                )
              : const SizedBox.shrink();

  Future<void> _getThumbnailImage(final String url) async {
    // get image
    try {
      final Response<List<int>> response = await dio.get<List<int>>(
        widget.baseUrlVttImages + url,
        options: Options(responseType: ResponseType.bytes),
      );

      // Convert to ui image
      thumbnailsImage = await _loadUiImage(
        Uint8List.fromList(response.data!),
      );
    } catch (e) {
      hasError = true;
      debugPrint(e.toString());
    }
    isLoading = false;

    if (mounted) {
      setState(() {});
    }
  }

  Future<ui.Image> _loadUiImage(final Uint8List img) async {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    ui.decodeImageFromList(img, completer.complete);
    return completer.future;
  }
}
