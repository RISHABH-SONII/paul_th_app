import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VideoPickerPage extends StatefulWidget {
  @override
  _VideoPickerPageState createState() => _VideoPickerPageState();
}

class _VideoPickerPageState extends State<VideoPickerPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _videoFile;

  // Function to pick video from gallery
  Future<void> _pickVideo() async {
    final XFile? pickedVideo =
        await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      setState(() {
        _videoFile = pickedVideo;
      });
    }
  }

  // Function to pick video from camera
  Future<void> _recordVideo() async {
    final XFile? recordedVideo =
        await _picker.pickVideo(source: ImageSource.camera);
    if (recordedVideo != null) {
      setState(() {
        _videoFile = recordedVideo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick a Video")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Pick a Video from Gallery'),
            ),
            ElevatedButton(
              onPressed: _recordVideo,
              child: Text('Record a Video'),
            ),
            if (_videoFile != null)
              Column(
                children: [
                  Text('Picked Video:'),
                  // Display the path or video thumbnail, or even use a player widget.
                  Text(_videoFile!.path),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: VideoPickerPage(),
  ));
}
