import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logger/logger.dart';
import 'package:sdp_transform/sdp_transform.dart';

var logger = Logger();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Call Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Audio Call Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final sdpOfferController = TextEditingController();
  final sdpAnswerController = TextEditingController();

  bool _offer = false;
  List<Map<String, dynamic>> _localCandidates = [];
  bool _isConnected = false;
  bool _isMuted = false;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  @override
  void initState() {
    super.initState();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
    });
  }

  @override
  void dispose() {
    _peerConnection?.dispose();
    _localStream?.dispose();
    sdpOfferController.dispose();
    sdpAnswerController.dispose();
    super.dispose();
  }

  Future<MediaStream> _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': false, // Disable video
    };

    try {
      MediaStream stream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
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
        print('\x1B[34mNew ICE candidate: ${json.encode(candidate)}\x1B[0m');
      }
    };

    pc.onIceConnectionState = (e) {
      print('\x1B[32mICE connection state changed: $e\x1B[0m');
      setState(() {
        _isConnected =
            e == RTCIceConnectionState.RTCIceConnectionStateConnected;
      });
    };

    return pc;
  }

  void _createOffer() async {
    setState(() {
      _localCandidates.clear();
      _offer = true;
    });

    try {
      RTCSessionDescription description = await _peerConnection!.createOffer({
        'offerToReceiveAudio': 1,
        'offerToReceiveVideo': 0, // Disable video
      });

      var session = parse(description.sdp.toString());

      await _peerConnection!.setLocalDescription(description);

      await waitForArrayData(_localCandidates);
      var offerWithCandidates = {
        'sdp': session,
        'type': 'offer',
        'candidates': _localCandidates,
      };
      sdpOfferController.text = json.encode(offerWithCandidates);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Offer created successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating offer: $e')),
      );
    }
  }

  void _setRemoteDescription() async {
    try {
      dynamic data = jsonDecode(sdpOfferController.text);

      String sdp = write(data["sdp"], null);

      RTCSessionDescription description = RTCSessionDescription(
        sdp,
        data['type'] ?? (_offer ? 'answer' : 'offer'),
      );

      await _peerConnection!.setRemoteDescription(description);

      if (data['candidates'] != null) {
        logger.f(jsonEncode(data['candidates']));
        for (var candidate in data['candidates']) {
          logger.f(jsonEncode(candidate));
          await _peerConnection!.addCandidate(RTCIceCandidate(
            candidate['candidate'],
            candidate['sdpMid'],
            candidate['sdpMlineIndex'],
          ));
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Remote description set successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error setting remote description: $e')),
      );
    }
  }

  void _createAnswer() async {
    setState(() {
      _localCandidates.clear();
      _offer = false;
    });

    try {
      RTCSessionDescription description = await _peerConnection!.createAnswer({
        'offerToReceiveAudio': 1,
        'offerToReceiveVideo': 0, // Disable video
      });

      var session = parse(description.sdp.toString());

      await _peerConnection!.setLocalDescription(description);

      await waitForArrayData(_localCandidates);

      var answerWithCandidates = {
        'sdp': session,
        'candidates': _localCandidates,
        'type': 'answer',
      };

      sdpAnswerController.text = json.encode(answerWithCandidates);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Answer created successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating answer: $e')),
      );
    }
  }

  void _toggleMute() async {
    if (_localStream == null) return;

    setState(() {
      _isMuted = !_isMuted;
    });

    final audioTracks = _localStream!.getAudioTracks();
    if (audioTracks.isNotEmpty) {
      audioTracks.first.enabled = !_isMuted;
    }
  }

  Widget _buildCallControls() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
              color: _isMuted ? Colors.red : Colors.blue,
              iconSize: 36,
              onPressed: _toggleMute,
            ),
            const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.call_end),
              color: Colors.red,
              iconSize: 36,
              onPressed: () {
                _peerConnection?.close();
                setState(() {
                  _isConnected = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSdpInputField() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Remote SDP/Candidates (paste here):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: sdpOfferController,
              maxLines: 5,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.paste),
                  onPressed: () async {
                    final data = await Clipboard.getData('text/plain');
                    if (data != null) {
                      sdpOfferController.text = data.text ?? '';
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSdpOutputField() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Local SDP (copy this):',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: sdpAnswerController,
              maxLines: 5,
              readOnly: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    if (sdpAnswerController.text.isNotEmpty) {
                      Clipboard.setData(
                          ClipboardData(text: sdpAnswerController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard!')),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.call_outlined),
              label: const Text("Offer"),
              onPressed: _createOffer,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.call_received),
              label: const Text("Answer"),
              onPressed: _createAnswer,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.settings_remote),
              label: const Text("Set Remote"),
              onPressed: _setRemoteDescription,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isConnected ? Icons.check_circle : Icons.error,
              color: _isConnected ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(
              _isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isConnected ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Audio Call Instructions'),
                  content: const SingleChildScrollView(
                    child: Text('''
1. Create Offer on Device A
2. Copy SDP from Device A and paste to Device B
3. On Device B, click "Set Remote"
4. On Device B, click "Create Answer"
5. Copy SDP from Device B and paste to Device A
6. On Device A, click "Set Remote"
7. Audio connection will be established
                    '''),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildConnectionStatus(),
            const SizedBox(height: 20),
            _buildCallControls(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 20),
            _buildSdpInputField(),
            const SizedBox(height: 20),
            _buildSdpOutputField(),
          ],
        ),
      ),
    );
  }
}

Future<void> waitForArrayData(List<dynamic> data) async {
  while (data.isEmpty) {
    print('Array is empty. Waiting for 2 seconds...');
    await Future.delayed(Duration(seconds: 2));
  }
  print('Array is now populated: $data');
}
