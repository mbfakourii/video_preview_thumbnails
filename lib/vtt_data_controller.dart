
import 'package:example/vtt_data_model.dart';
import 'package:example/subtitle_utils.dart';

class VttDataController {
  final String fileContents;

  List<VttDataModel> get vttData => _vttData;

  final List<VttDataModel> _vttData;

  bool get isEmpty => vttData.isEmpty;

  bool get isNotEmpty => !isEmpty;

  VttDataController.string(this.fileContents)
      : _vttData = parseFromWebVTTString(fileContents);

  VttDataModel vttDataFromMilliseconds(int milliseconds) {
    final selectedVttData = _vttData.lastWhere(
          (data) => milliseconds >= (data.start) && milliseconds <= (data.end),
      orElse: () => VttDataModel.empty,
    );
    return selectedVttData;
  }
}
