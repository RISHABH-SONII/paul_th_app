import 'dart:async';

import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class ItemVideo extends StatefulWidget {
  ItemVideoState? item;
  final VideoPlayerController? videoPlayerController;
  final String? videoUrl;

  ItemVideo({this.videoUrl, this.videoPlayerController});

  @override
  ItemVideoState createState() => ItemVideoState();
}

class ItemVideoState extends State<ItemVideo> {
  bool isPlaying = false;
  bool showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _hideControlsTimer?.cancel();
    await widget.videoPlayerController?.pause();
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
    return Stack(
      children: [
        InkWell(
          onTap: _onTap,
          child: SizedBox.expand(
            child: FittedBox(
              fit: (widget.videoPlayerController?.value.size.width ?? 0) <
                      (widget.videoPlayerController?.value.size.height ?? 0)
                  ? BoxFit.cover
                  : BoxFit.fitWidth,
              child: SizedBox(
                width: widget.videoPlayerController?.value.size.width ?? 0,
                height: widget.videoPlayerController?.value.size.height ?? 0,
                child: widget.videoPlayerController != null
                    ? VideoPlayer(
                        widget.videoPlayerController!,
                      )
                    : SizedBox(),
              ),
            ),
          ),
        ),
        if (showControls)
          InkWell(
            onTap: _onTap,
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
      ],
    );
  }

  void _onTap() {
    if (widget.videoPlayerController != null &&
        widget.videoPlayerController!.value.isPlaying) {
      widget.videoPlayerController?.pause();
    } else {
      widget.videoPlayerController?.play();
    }
    isPlaying = !isPlaying;
    _resetHideControlsTimer();
  }
}
