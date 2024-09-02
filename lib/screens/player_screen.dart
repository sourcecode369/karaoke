import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:microphone/microphone.dart'; // Add microphone package

import '../models/song.dart';
import '../utils/lyrics_utils.dart';

class PlayerScreen extends StatefulWidget {
  final Song song;

  const PlayerScreen({super.key, required this.song});

  @override
  // ignore: library_private_types_in_public_api
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer player;
  late MicrophoneRecorder _recorder; // Microphone recorder instance
  bool _isKaraokeMode = false; // Karaoke mode flag
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String _lyrics = '';
  List<Widget> _parsedLyrics = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    _initPlayer();
    _loadLyrics();
    _initMicrophone();
  }

  // Initialize microphone recorder
  void _initMicrophone() {
    _recorder = MicrophoneRecorder()..init();
  }

  void _toggleKaraokeMode() {
    // Assuming you have a method to check if the player is currently playing
    bool isPlayerPlaying = _isPlayerPlaying();

    if (_isKaraokeMode) {
      // Currently ON, turning OFF
      setState(() {
        _isKaraokeMode = false;
        // _stopRecording();
        _showKaraokeSnackBar();
      });
      _showPostKaraokeOptions();
    } else {
      if (isPlayerPlaying) {
        // Currently OFF and player is playing, turning ON
        setState(() {
          _isKaraokeMode = true;
          _startRecording();
          _showKaraokeSnackBar();
        });
      } else {
        // Player is not playing, show a message or handle this case
        _showPlayerNotPlayingMessage();
      }
    }
  }

// Example method to check if the player is playing
  bool _isPlayerPlaying() {
    // Replace with your actual logic to check the player's state
    return _playerState ==
        PlayerState.playing; // or false based on the actual state of the player
  }

// Example method to show a message when the player is not playing
  void _showPlayerNotPlayingMessage() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.play_arrow,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'Karaoke Mode requires the player to be active.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showPostKaraokeOptions() {
    player.pause();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Karaoke Session Ended',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).colorScheme.onSurface,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Text(
            'Would you like to listen to your performance or get a score analysis?',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _listenToRecording();
              },
              child: Text(
                'Listen to What You Sang',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // _performScoreAnalysis();
              },
              child: Text(
                'Score Analysis',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          actionsPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        );
      },
    );
  }

  void _testRecorderStop() async {
    print(">>>>>>>>> Testing Recorder Stop");

    // Check if recorder is not null
    if (_recorder == null) {
      print("Recorder is not initialized.");
      return;
    }

    try {
      await _recorder.stop();
    } catch (e) {
      print("Error stopping recorder: $e");
      return;
    }

    final value = _recorder.value;
    print(">>>>>>>>> Recorder value: $value");

    if (value != null && value.stopped) {
      print("Recording stopped successfully.");
    } else {
      print("Failed to stop recording or no recording found.");
    }
  }

  void _listenToRecording() async {
    _testRecorderStop();
    print(">>>>>>>>> inside");

    // Check if recorder is not null
    if (_recorder == null) {
      print("Recorder is not initialized.");
      return;
    }

    try {
      // Stop recording and handle potential errors
      await _recorder.stop();
    } catch (e) {
      print("Error stopping recorder: $e");
      return;
    }

    // Verify if the value is populated
    final value = _recorder.value;
    print(">>>>>>>>> Recorder value: $value");

    if (value != null && value.stopped) {
      // Create a new AudioPlayer instance for playback
      AudioPlayer playbackPlayer = AudioPlayer();
      await playbackPlayer.play(UrlSource(value.recording?.url as String));

      // Optional: Show a dialog or a new screen with playback controls
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Your Recording'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Playing back your performance.'),
                const SizedBox(height: 20),
                // Add playback controls if needed
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  playbackPlayer.stop();
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      // Handle the case where there's no recording
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No recording found to play.')),
      );
    }
  }

  // Start recording user's voice
  void _startRecording() async {
    await _recorder.start();
  }

  // Stop recording user's voice
  void _stopRecording() async {
    await _recorder.stop();
  }

  void _showKaraokeSnackBar() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            _isKaraokeMode ? Icons.mic : Icons.mic_off,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          SizedBox(width: 10),
          Text(
            _isKaraokeMode ? 'Karaoke mode is ON' : 'Karaoke mode is OFF',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      backgroundColor: _isKaraokeMode
          ? Theme.of(context).primaryColor
          : Theme.of(context).colorScheme.secondary,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(seconds: 2),
    );

    // Show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _initPlayer() async {
    await player.setSource(AssetSource(widget.song.filePath));
    await player.resume();

    _showKaraokeSnackBar();
    _playerState = player.state;
    _duration = await player.getDuration() ?? Duration.zero;
    _position = await player.getCurrentPosition() ?? Duration.zero;

    player.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    player.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });

    player.onPlayerComplete.listen((event) {
      setState(() {
        _position = Duration.zero;
      });
    });
  }

  Future<void> _loadLyrics() async {
    final lyrics = await loadLyrics(widget.song.lyricsPath);
    setState(() {
      _lyrics = lyrics;
      _parsedLyrics = parseLyrics(_lyrics);
    });
  }

  @override
  void dispose() {
    player.stop();
    _recorder.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _playerState == PlayerState.playing;

    return Scaffold(
      backgroundColor: Colors.black, // Set a solid dark background
      appBar: AppBar(
        title: Text(widget.song.title),
        backgroundColor:
            Colors.black87, // Darker app bar color for better contrast
        actions: [
          IconButton(
            icon: Icon(
              _isKaraokeMode ? Icons.mic_off : Icons.mic,
              color: Colors.white,
            ),
            onPressed: _toggleKaraokeMode, // Toggle karaoke mode
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: Image.asset(
                        widget.song.albumArt,
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  widget.song.title,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.song.artist,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[400],
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _parsedLyrics,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Colors.blueGrey[600],
                    inactiveTrackColor: Colors.grey[700],
                    thumbColor: Colors.blueGrey[700],
                    overlayColor: Colors.blueGrey.withOpacity(0.2),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    min: 0,
                    max: _duration.inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble(),
                    onChanged: (value) {
                      final position = Duration(seconds: value.toInt());
                      player.seek(position);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_position)),
                      Text(_formatDuration(_duration - _position)),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous, color: Colors.white),
                      onPressed: () {}, // Implement skip previous
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey[700],
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(16),
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          player.pause();
                        } else {
                          player.resume();
                        }
                      },
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next, color: Colors.white),
                      onPressed: () {}, // Implement skip next
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }
}
