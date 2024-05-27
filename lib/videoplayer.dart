import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  VideoPlayerWidget({required this.videoUrl, });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late bool _isPlaying;

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Lorsque le contrôleur est initialisé, commencez à lire automatiquement
        setState(() {
          _isPlaying = true;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
        IconButton(
          icon: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
          ),
          onPressed: () {
            setState(() {
              if (_isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
              _isPlaying = !_isPlaying;
            });
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
