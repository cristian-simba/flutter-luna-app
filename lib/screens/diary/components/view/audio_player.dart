import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YouTubeAudioPlayer extends StatefulWidget {
  final String youtubeUrl;
  final String songName;

  const YouTubeAudioPlayer({
    Key? key,
    required this.youtubeUrl,
    required this.songName,
  }) : super(key: key);

  @override
  _YouTubeAudioPlayerState createState() => _YouTubeAudioPlayerState();
}

class _YouTubeAudioPlayerState extends State<YouTubeAudioPlayer> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final yt = YoutubeExplode();
      final video = await yt.videos.get(widget.youtubeUrl);
      final manifest = await yt.videos.streamsClient.getManifest(video.id);
      final audioStream = manifest.audioOnly.withHighestBitrate();
      final audioUrl = audioStream.url.toString();

      await _audioPlayer.setUrl(audioUrl);
      
      _audioPlayer.playerStateStream.listen((state) {
        if (mounted) {
          setState(() {
            _isPlaying = state.playing;
          });
        }
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar el audio: ${e.toString()}';
      });
    }
  }

  void _togglePlayPause() {
    if (_errorMessage != null) {
      _initAudioPlayer(); // Reintentar si hubo un error
    } else if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (_isLoading)
          CircularProgressIndicator()
        else
          IconButton(
            icon: Icon(_errorMessage != null
                ? Icons.error
                : (_isPlaying ? Icons.pause : Icons.play_arrow)),
            onPressed: _togglePlayPause,
            color: _errorMessage != null ? Colors.red : null,
          ),
        // const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.songName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
            ],
          ),
        ),
      ],
    );
  }
}