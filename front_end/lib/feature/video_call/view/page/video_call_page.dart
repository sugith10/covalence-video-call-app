import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class VideoCallPage extends StatefulWidget {
  final String roomId;

  const VideoCallPage({required this.roomId, Key? key}) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  late IO.Socket socket;
  late RTCPeerConnection _peerConnection;
  late MediaStream _localStream;

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
    _connectToSocket();
    _initializeMedia();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    socket.dispose();
    _localStream.dispose();
    _peerConnection.close();
    super.dispose();
  }

  Future<void> _initializeRenderers() async {
    try {
      await _localRenderer.initialize();
      await _remoteRenderer.initialize();
    } catch (e) {
      log('Error initializing renderers: $e');
    }
  }

  void _connectToSocket() {
    log("Connecting to socket");
    try {
      socket = IO.io('http://10.4.2.248:3001', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.on('connect', (_) {
        log('Socket connected');
        socket.emit('join-room', {
          'roomId': widget.roomId,
        });
      });

      socket.on('joined-room', (data) {
        log('Joined room: ${data['roomId']}');
      });

      socket.on('user-joined', (data) {
        log('User joined: ${data['email']}');
      });

      socket.on('incoming-call', (data) async {
        var from = data['from'];
        var offer = data['offer'];

        try {
          await _peerConnection.setRemoteDescription(
              RTCSessionDescription(offer['sdp'], offer['type']));
          var answer = await _peerConnection.createAnswer();
          await _peerConnection.setLocalDescription(answer);

          socket.emit('call-accepted', {
            'from': from,
            'ans': {
              'type': answer.type,
              'sdp': answer.sdp,
            },
          });
        } catch (e) {
          log('Error handling incoming call: $e');
        }
      });

      socket.on('call-accepted', (data) async {
        var ans = data['ans'];
        try {
          await _peerConnection.setRemoteDescription(
              RTCSessionDescription(ans['sdp'], ans['type']));
        } catch (e) {
          log('Error handling call accepted: $e');
        }
      });

      socket.connect();
    } catch (e) {
      log('Error connecting to socket: $e');
    }
  }

  Future<void> _initializeMedia() async {
    try {
      _localStream = await navigator.mediaDevices.getUserMedia({
        'video': true,
        'audio': true,
      });

      _localRenderer.srcObject = _localStream;

      _peerConnection = await createPeerConnection({
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'}
        ],
        'sdpSemantics': 'unified-plan',
      });

      _localStream.getTracks().forEach((track) {
        _peerConnection.addTrack(track, _localStream);
      });

      _peerConnection.onIceCandidate = (RTCIceCandidate candidate) {
        if (candidate != null) {
          socket.emit('ice-candidate', {
            'candidate': candidate.toMap(),
          });
        }
      };

      _peerConnection.onTrack = (RTCTrackEvent event) {
        if (event.streams.isNotEmpty) {
          setState(() {
            _remoteRenderer.srcObject = event.streams[0];
          });
        }
      };
    } catch (e) {
      log('Error initializing media: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call - Room ID: ${widget.roomId}'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: RTCVideoView(_localRenderer),
            ),
            Expanded(
              child: RTCVideoView(_remoteRenderer),
            ),
          ],
        ),
      ),
    );
  }
}
