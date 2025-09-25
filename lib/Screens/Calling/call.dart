import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tharkyApp/Screens/Chat/Matches.dart';
import 'package:tharkyApp/Screens/Chat/chatPage.dart';
import 'package:tharkyApp/components/back_widget.dart';
import 'package:tharkyApp/components/copole2.dart';
import 'package:tharkyApp/main.dart';
import 'package:tharkyApp/models/user_model.dart';
import 'package:tharkyApp/network/rest_apis.dart';
import 'package:tharkyApp/utils/colors.dart';
import 'package:tharkyApp/utils/model_keys.dart';
import 'package:tharkyApp/utils/utls.dart';
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:nb_utils/nb_utils.dart'; // You can remove this if it's not used in the updated widget

class CallPage extends StatefulWidget {
  final User other;
  final String callType;
  final bool? iscalling;

  // Creates a call page with given channel name.
  const CallPage(
      {Key? key,
      required this.callType,
      this.iscalling = false,
      required this.other})
      : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  bool muted = false;

  bool disable = false;
  List<Map<String, dynamic>> _localCandidates = [];
  bool _isConnected = false;
  bool _isMuted = false;
  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  RTCDataChannel? _dataChannel; // Add this with your other variables

// Add these new variables to your state class
  Duration _callDuration = Duration.zero;
  Timer? _callTimer;
  bool _isTimerRunning = false;
  bool _remoteCameraEnabled = true;
  @override
  void initState() {
    super.initState();
    _createPeerConnection().then((pc) {
      appController.peerConnection = pc;
      if (widget.iscalling ?? false) {
        //2---> initiation de rouge 1
        _createOffer();
      } else {}
      Rks.createAnswer = _createAnswer;
    });
    if (widget.callType == "VideoCall") {
      initRenderer();
    }
  }

  @override
  void dispose() {
    _localVideoRenderer.dispose();
    _remoteVideoRenderer.dispose();
    appController.peerConnection?.dispose();
    _localStream?.dispose();
    _callTimer?.cancel();
    _dataChannel?.close();
    _dataChannel = null;

    super.dispose();
  }

  Future<void> initRenderer() async {
    await _localVideoRenderer.initialize();
    await _remoteVideoRenderer.initialize();
  }

  Future<MediaStream> _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': widget.callType == "VideoCall"
          ? {
              'facingMode': 'user',
              'width': 1280,
              'height': 720,
              'frameRate': 30,
            }
          : false,
    };

    try {
      MediaStream stream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      if (widget.callType == "VideoCall") {
        _localVideoRenderer.srcObject = stream;
      }
      return stream;
    } catch (e) {
      print('Error getting user media: $e');
      rethrow;
    }
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
        {"url": "stun:stun1.l.google.com:19302"},
        {"url": "stun:stun2.l.google.com:19302"},
      ]
    };

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": false, // Disable video
      },
      "optional": [],
    };

    _localStream = await _getUserMedia();

    RTCPeerConnection pc =
        await createPeerConnection(configuration, offerSdpConstraints);

    _localStream?.getTracks().forEach((track) {
      pc.addTrack(track, _localStream!);
    });

    pc.onIceCandidate = (e) {
      if (e.candidate != null) {
        final candidate = {
          'candidate': e.candidate.toString(),
          'sdpMid': e.sdpMid.toString(),
          'sdpMlineIndex': e.sdpMLineIndex,
        };
        setState(() {
          _localCandidates.add(candidate);
        });
      }
    };
    pc.onIceConnectionState = (state) {
      if (state == RTCIceConnectionState.RTCIceConnectionStateClosed &&
          (widget.iscalling ?? false)) {
        Rks.closeCall();
      }
      setState(() {
        _isConnected =
            state == RTCIceConnectionState.RTCIceConnectionStateConnected ||
                state == RTCIceConnectionState.RTCIceConnectionStateCompleted;

        if (_isConnected && !_isTimerRunning) {
          _startCallTimer();
        } else if (!_isConnected && _isTimerRunning) {
          _stopCallTimer();
        }
      });
    };

    if (widget.callType == "VideoCall") {
      pc.onAddTrack = (stream, track) {
        setState(() {
          _remoteVideoRenderer.srcObject = stream;
        });
      };
      pc.onTrack = (event) {
        if (event.track.kind == 'video') {
          setState(() {
            _remoteVideoRenderer.srcObject = event.streams[0];
          });
        }
      };
    }

    // Create data channel for camera status updates
    _dataChannel = await pc.createDataChannel(
        'camera-control',
        RTCDataChannelInit()
          ..ordered = true
          ..maxRetransmits = 30);

    _dataChannel!.onMessage = (message) {
      final data = json.decode(message.text);
      if (data['type'] == 'camera_status') {
        setState(() {
          _remoteCameraEnabled = data['enabled'];
        });
      }
    };

    pc.onDataChannel = (channel) {
      if (channel.label == 'camera-control') {
        _dataChannel = channel;
        channel.onMessage = (message) {
          if (!message.isBinary) {
            final data = json.decode(message.text);
            if (data['type'] == 'camera_status') {
              setState(() {
                _remoteCameraEnabled = data['enabled'];
              });
            }
          }
        };
      }
    };

    return pc;
  }

  void _createOffer() async {
    setState(() {
      _localCandidates.clear();
    });

    try {
      RTCSessionDescription description =
          await appController.peerConnection!.createOffer({
        'offerToReceiveAudio': 1,
        'offerToReceiveVideo': widget.callType == "VideoCall" ? 1 : 0,
      });

      var session = parse(description.sdp.toString());

      await appController.peerConnection!.setLocalDescription(description);
      await waitForArrayData(_localCandidates);

      var offerCandidates = {
        'sdp': session,
        'type': 'offer',
        'candidates': _localCandidates,
      };
      await postofferCandidates({
        "sdpOfferController": json.encode(offerCandidates),
        "room": appController.room.value!.id,
        'type': 'offer',
      });
    } catch (e) {
      inspect(e);
    }
  }

  _createAnswer() async {
    setState(() {
      _localCandidates.clear();
    });

    try {
      RTCSessionDescription description =
          await appController.peerConnection!.createAnswer({
        'offerToReceiveAudio': 1,
        'offerToReceiveVideo':
            widget.callType == "VideoCall" ? 1 : 0, // Disable video
      });

      var session = parse(description.sdp.toString());

      await appController.peerConnection!.setLocalDescription(description);

      await waitForArrayData(_localCandidates);

      var answerWithCandidates = {
        'sdp': session,
        'candidates': _localCandidates,
        'type': 'answer',
      };

      postofferCandidates({
        "sdpOfferController": json.encode(answerWithCandidates),
        "room": Rks.callinlingRoom!.id,
        'type': 'answer',
      });
    } catch (e) {
      inspect(e);
    }
  }

// Add these methods to start/stop the timer
  void _startCallTimer() {
    _callDuration = Duration.zero;
    _isTimerRunning = true;
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _callDuration += const Duration(seconds: 1);
      });
    });
  }

  void _stopCallTimer() {
    _callTimer?.cancel();
    _isTimerRunning = false;
  }

  List<Widget> _getRenderViews() {
    final List<Widget> list = [];

    if (widget.callType == "VideoCall") {
      // Local video view with connection status and camera controls
      list.add(
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isConnected ? Colors.green : Colors.blue,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: RTCVideoView(_localVideoRenderer),
              ),
            ),
            if (disable)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        Icon(
                          disable ? Icons.videocam_off : Icons.videocam,
                          color: Colors.white,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.switch_camera, color: Colors.white),
                    onPressed: _onSwitchCamera,
                  ),
                  IconButton(
                    icon: Icon(
                      disable ? Icons.videocam_off : Icons.videocam,
                      color: disable ? Colors.red : Colors.white,
                    ),
                    onPressed: _disVideo,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      list.add(
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isConnected ? Colors.green : Colors.red,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                if (_remoteCameraEnabled)
                  RTCVideoView(_remoteVideoRenderer)
                else
                  Container(
                    color: Colors.black,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.videocam_off,
                              size: 50, color: Colors.white54),
                          Text(
                            'Camera disabled',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!_isConnected) // Show waiting status
                  Positioned.fill(
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: Text(
                          'Waiting for connection...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return list;
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            expandedVideoRow([views[0]]),
            expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            expandedVideoRow(views.sublist(0, 2)),
            expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            expandedVideoRow(views.sublist(0, 2)),
            expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _videoToolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _audioToolbar(type: "video"),
        ],
      ),
    );
  }

  Widget _audioToolbar({String type: "audio"}) {
    double iconSize = 36;
    if (type == "video") {
      iconSize = 24;
    }

    return Card(
      elevation: 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.message),
            color: Colors.blue,
            iconSize: iconSize,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => ChatPage(
                    sender: Rks.currentUser!,
                    second: widget.other,
                    room: appController.room.value,
                  ),
                ),
              );
            },
          ),
          20.width,
          IconButton(
            icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
            color: _isMuted ? Colors.red : Colors.blue,
            iconSize: iconSize,
            onPressed: _toggleMute,
          ),
          20.width,
          IconButton(
            icon: const Icon(Icons.call_end),
            color: Colors.red,
            iconSize: iconSize,
            onPressed: () {
              appController.peerConnection?.close();
              setState(() {
                _isConnected = false;
              });
              Rks.closeCall();
            },
          ),
        ],
      ).paddingAll(12),
    );
  }

  void _toggleMute() {
    if (_localStream == null) return;

    setState(() {
      _isMuted = !_isMuted;
    });

    final audioTracks = _localStream!.getAudioTracks();
    if (audioTracks.isNotEmpty) {
      audioTracks.first.enabled = !_isMuted;
    }
  }

  void _onSwitchCamera() {
    if (_localStream == null) return;

    // Get all video tracks from local stream
    final videoTracks = _localStream!.getVideoTracks();
    if (videoTracks.isEmpty) return;

    // Toggle between front and back camera
    setState(() {
      Helper.switchCamera(videoTracks.first);
    });
  }

  void _disVideo() async {
    if (_localStream == null) return;

    setState(() {
      disable = !disable;

      // Toggle video tracks
      final videoTracks = _localStream!.getVideoTracks();
      if (videoTracks.isNotEmpty) {
        videoTracks.first.enabled = !disable;
      }
    });

    // Send camera status through the data channel
    if (_dataChannel != null &&
        _dataChannel!.state == RTCDataChannelState.RTCDataChannelOpen) {
      try {
        await _dataChannel!.send(RTCDataChannelMessage(json.encode({
          'type': 'camera_status',
          'enabled': !disable,
        })));
      } catch (e) {
        log('Error sending camera status: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            // Background image
            Positioned.fill(
              child: Image.asset(
                'asset/call_background.jpg', // Change to your image path
                fit: BoxFit.cover, // Ensures the image covers the screen
              ),
            ),
            // Call Type Content
            widget.callType == "VideoCall"
                ? _viewRows()
                : Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: Text(
                          widget.other.name ?? "Unknown",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      2.height,
                      Text(
                        _isConnected
                            ? formatDuration(_callDuration)
                            : 'Connecting...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _isConnected ? Colors.green : Colors.orange,
                        ),
                      ),
                      50.height,
                      Container(
                        alignment: Alignment.center,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            100,
                          ),
                          child: CachedNetworkImage(
                            width: 200,
                            height: 200,
                            imageUrl: imageUrl(widget.other.imageUrl![0])!,
                            useOldImageOnUrlChange: true,
                            placeholder: (context, url) => loadingImage(),
                            errorWidget: (context, url, error) => errorImage(),
                          ),
                        ),
                      ),
                    ],
                  ),
            // Toolbar at the bottom
            widget.callType == "VideoCall"
                ? Positioned(
                    bottom: 10, left: 10, right: 10, child: _videoToolbar())
                : Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: _audioToolbar(),
                  ),
          ],
        ),
      ),
    );
  }
}
