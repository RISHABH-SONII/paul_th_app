import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallScreen extends StatefulWidget {
  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late IO.Socket socket;
  late RTCPeerConnection peerConnection;
  late RTCVideoRenderer localRenderer;
  final Map<String, RTCVideoRenderer> remoteRenderers = {};
  final String roomId = 'room1'; // Room ID for testing

  @override
  void initState() {
    super.initState();
    initSocket();
    initWebRTC();
  }

  void initSocket() {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected to server');
      socket.emit('joinRoom', {'roomId': roomId});
    });

    socket.on('newProducer', (data) {
      print('New producer: ${data['producerId']}');
      // Consume the new producer's media
      socket.emit('consume', {
        'producerId': data['producerId'],
        ///Commented by Shubham
        //'rtpCapabilities': peerConnection.getCapabilities(),
      });
    });

    socket.on('newConsumer', (data) {
      print('New consumer: ${data['consumerId']}');
      // Add the remote stream to the UI
      addRemoteStream(data['consumerId'], data['stream']);
    });

    socket.on('participantLeft', (data) {
      print('Participant left: ${data['participantId']}');
      // Remove the participant's video renderer
      setState(() {
        remoteRenderers.remove(data['participantId']);
      });
    });
  }

  void initWebRTC() async {
    localRenderer = RTCVideoRenderer();
    await localRenderer.initialize();

    peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    });

    peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
      socket.emit('iceCandidate', {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };

    peerConnection.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        final renderer = RTCVideoRenderer();
        renderer.initialize().then((_) {
          setState(() {
            remoteRenderers[event.streams[0].id] = renderer;
            renderer.srcObject = event.streams[0];
          });
        });
      }
    };

    // Get user media
    final localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });

    localRenderer.srcObject = localStream;
    localStream.getTracks().forEach((track) {
      peerConnection.addTrack(track, localStream);
    });

    // Create transport and produce
    socket.emit('createTransport', (data) {
      print('Transport created: $data');
    });
  }

  void addRemoteStream(String consumerId, MediaStream stream) {
    final renderer = RTCVideoRenderer();
    renderer.initialize().then((_) {
      setState(() {
        remoteRenderers[consumerId] = renderer;
        renderer.srcObject = stream;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mediasoup Flutter App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(localRenderer),
          ),
          for (var renderer in remoteRenderers.values)
            Expanded(
              child: RTCVideoView(renderer),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    localRenderer.dispose();
    for (var renderer in remoteRenderers.values) {
      renderer.dispose();
    }
    super.dispose();
  }
}
