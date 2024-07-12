import 'package:video_preview_thumbnails/video_preview_thumbnails.dart';

class VttDataController {
  VttDataController.string(this.fileContents)
      : _vttData = parseFromWebVTTString(fileContents);
  final String fileContents;

  List<VttDataModel> get vttData => _vttData;

  final List<VttDataModel> _vttData;

  bool get isEmpty => vttData.isEmpty;

  bool get isNotEmpty => !isEmpty;

  VttDataModel vttDataFromMilliseconds(final int milliseconds) {
    final VttDataModel selectedVttData = _vttData.lastWhere(
      (final VttDataModel data) =>
          milliseconds >= (data.start) && milliseconds <= (data.end),
      orElse: () => VttDataModel.empty,
    );
    return selectedVttData;
  }
}
