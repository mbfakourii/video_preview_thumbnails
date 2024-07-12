import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_preview_thumbnails/video_preview_thumbnails.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) => const MaterialApp(
        title: 'Video preview thumbnails example',
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: 'Video preview thumbnails example'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? vttFile;
  VideoPreviewThumbnailsController controller =
      VideoPreviewThumbnailsController();

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            _addMoveCurrentTime(15500),
            _addMoveCurrentTime(21500),
            _addMoveCurrentTime(18000),
            _addMoveCurrentTime(29000),
            _addMoveCurrentTime(39000),
            _addMoveCurrentTime(49000),
            const SizedBox(height: 20),
            Center(
              child: Container(
                constraints:
                    const BoxConstraints(maxHeight: 150, maxWidth: 300),
                child: (vttFile != null)
                    ? VideoPreviewThumbnails(
                        vtt: vttFile!,
                        controller: controller,
                        scale: 5,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      );

  Future<Uint8List> loadVtt() async {
    final ByteData data = await rootBundle.load('assets/tooltip.vtt');
    return data.buffer.asUint8List();
  }

  Future<void> load() async {
    vttFile = await loadVtt();
    setState(() {});
  }

  Widget _addMoveCurrentTime(final int value) => OutlinedButton(
        onPressed: () {
          controller.setCurrentTime(value);
        },
        child: Text('Move to $value Milliseconds'),
      );
}
