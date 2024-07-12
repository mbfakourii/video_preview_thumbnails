class VttDataModel {
  const VttDataModel({
    required this.number,
    required this.start,
    required this.end,
    required this.text,
    required this.imageUrl,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  /// Number data in vtt file.
  final int number;

  /// Start vtt time base millisecond.
  final int start;

  /// End vtt time base millisecond.
  final int end;

  /// Text in vtt file.
  final String text;

  /// Vtt image url.
  final String imageUrl;

  /// Current x position in vtt image.
  final int x;

  /// Current y position in vtt image.
  final int y;

  /// Width vtt image.
  final int w;

  /// Height vtt image.
  final int h;

  /// Generate empty model.
  static VttDataModel empty = const VttDataModel(
    text: '',
    imageUrl: '',
    number: -1,
    start: -1,
    end: -1,
    h: 0,
    w: 0,
    x: 0,
    y: 0,
  );
}
