import 'package:flutter/material.dart';
import '../../providers/fakechat)provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:location/location.dart' as loc;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import '../../../../../core/util/builders/image_picker.dart';
import 'package:flutter/scheduler.dart';

class MessageSenderFake extends StatefulWidget {
  final String orderId;
  final FakeChatProvider fakeChatProvider;
  const MessageSenderFake({
    required this.orderId,
    required this.fakeChatProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<MessageSenderFake> createState() => _MessageSenderFakeState();
}

class _MessageSenderFakeState extends State<MessageSenderFake> {
  final TextEditingController _controller = TextEditingController();
  bool _isRecording = false;
  FlutterSoundRecorder? _recorder;
  String? _audioPath;
  Duration _recordDuration = Duration.zero;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _recorder!.openRecorder();
    _ticker = Ticker(_onTick);
  }

  void _onTick(Duration elapsed) {
    if (_isRecording) {
      setState(() {
        _recordDuration = elapsed;
      });
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _recorder?.closeRecorder();
    _controller.dispose();
    super.dispose();
  }

  void _sendText() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      await widget.fakeChatProvider.sendTextMessage(text, 'me');
      _controller.clear();
    }
  }

  Future<void> _sendImage() async {
    final XFile? picked = await myImagePicker(context);
    if (picked != null) {
      await widget.fakeChatProvider.sendImageMessage(picked.path, 'me');
    }
  }

  Future<void> _sendLocation() async {
    final loc.Location location = loc.Location();
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }
    loc.PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) return;
    }
    final loc.LocationData _locationData = await location.getLocation();
    final lat = _locationData.latitude;
    final lng = _locationData.longitude;
    if (lat != null && lng != null) {
      await widget.fakeChatProvider.sendLocationMessage('$lat,$lng', 'me');
    }
  }

  Future<void> _startRecording() async {
    Directory tempDir = await getTemporaryDirectory();
    _audioPath = '${tempDir.path}/fake_audio_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder!.startRecorder(toFile: _audioPath, codec: Codec.aacADTS);
    setState(() {
      _isRecording = true;
      _recordDuration = Duration.zero;
    });
    _ticker.start();
  }

  Future<void> _stopAndSendRecording() async {
    await _recorder!.stopRecorder();
    _ticker.stop();
    setState(() {
      _isRecording = false;
    });
    if (_audioPath != null) {
      await widget.fakeChatProvider.sendAudioMessage(_audioPath!, 'me');
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final m = twoDigits(d.inMinutes.remainder(60));
    final s = twoDigits(d.inSeconds.remainder(60));
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            tooltip: 'Send Image',
            onPressed: _sendImage,
          ),
          _isRecording
              ? Row(
                  children: [
                    Text(_formatDuration(_recordDuration), style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.send),
                      tooltip: 'Send Audio',
                      color: Colors.green,
                      onPressed: _stopAndSendRecording,
                    ),
                  ],
                )
              : IconButton(
                  icon: const Icon(Icons.mic),
                  tooltip: 'Record Audio',
                  onPressed: _startRecording,
                ),
          IconButton(
            icon: const Icon(Icons.location_on),
            tooltip: 'Send Location',
            onPressed: _sendLocation,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onSubmitted: (_) => _sendText(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendText,
          ),
        ],
      ),
    );
  }
}