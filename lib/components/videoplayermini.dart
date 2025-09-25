import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class MiniVideoPlayerWidget extends StatefulWidget {
  final String? videoUrl;
  final bool? swipping;
  final bool? play;
  final String? videoFilePath;

  MiniVideoPlayerWidget(
      {this.videoUrl, this.swipping, this.videoFilePath, this.play});

  @override
  _MiniVideoPlayerWidgetState createState() => _MiniVideoPlayerWidgetState();
}

class _MiniVideoPlayerWidgetState extends State<MiniVideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool isPlaying = false;
  bool showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    if (widget.videoFilePath != null) {
      _controller = VideoPlayerController.file(File(widget.videoFilePath!));
    } else {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!))
            ..initialize().then((_) {
              setState(() {});
              if (widget.play ?? false) {
                _controller.play();
                _onScreenTapped();
                isPlaying = !isPlaying;
              }
              if (widget.swipping ?? false) {
                _controller.setLooping(true);
                _onScreenTapped();
                isPlaying = !isPlaying;
              }
            });
      ;
    }

    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(_onVideoPlayerStateChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_onVideoPlayerStateChanged);
    _controller.dispose();
    _hideControlsTimer?.cancel();
  }

  // Function to handle state changes, including when video reaches the end
  void _onVideoPlayerStateChanged() {
    if (_controller.value.position == _controller.value.duration) {
      setState(() {
        isPlaying = false;
        showControls = true; // Show controls again when video ends
      });
    }
  }

  void togglePlayPause() {
    setState(() {
      if (isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      isPlaying = !isPlaying;
      _resetHideControlsTimer();
    });
  }

  void _onScreenTapped() {
    setState(() {
      showControls = !showControls;
    });
    _resetHideControlsTimer();
  }

  // Function to reset the timer when the user interacts
  void _resetHideControlsTimer() {
    _hideControlsTimer?.cancel(); // Cancel any existing timer
    _hideControlsTimer = Timer(Duration(seconds: 3), () {
      setState(() {
        showControls = false; // Hide controls after 3 seconds of inactivity
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double? videoHeight =
        widget.swipping == true ? MediaQuery.of(context).size.height : null;

    return GestureDetector(
      onTap: _onScreenTapped,
      child: FutureBuilder<void>(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: videoHeight,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                LinearProgressIndicator(
                  color: black,
                  backgroundColor: primaryColor,
                  minHeight: 5,
                ),
              ],
            )/*.yellowed(color: blackColor)*/;
            ///Commented by Shubham
          }
        },
      ),
    );
  }
}
