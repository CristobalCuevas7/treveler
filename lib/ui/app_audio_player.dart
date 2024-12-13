import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:treveler/domain/entities/guide_point.dart';
import 'package:treveler/style/colors.dart';
import 'package:treveler/style/dimensions.dart';
import 'package:treveler/util/app_icons.dart';
import 'package:treveler/util/log.dart';

Reference get firebaseStorage => FirebaseStorage.instance.ref();

class AppAudioPlayer extends StatefulWidget {
  final GuidePoint _guidePoint;

  const AppAudioPlayer(this._guidePoint, {super.key});

  @override
  State<AppAudioPlayer> createState() => _AppAudioPlayerState();
}

class _AppAudioPlayerState extends State<AppAudioPlayer> {

  final _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoading = true;
  Duration? _audioDuration;
  Duration? _currentPosition;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _initAudio();
    _listenToPositionUpdates();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  void _listenToPositionUpdates() {
    _positionSubscription?.cancel();
    _positionSubscription = _player.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  void _listenPlayerUpdates() {
    _playerStateSubscription?.cancel();
    _playerStateSubscription = _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      setState(() {
        _isPlaying = isPlaying;
        _isLoading = processingState == ProcessingState.loading || processingState == ProcessingState.buffering;
      });
    });
  }

  Future<void> _initAudio() async {
    try {
      setState(() {
        _isLoading = true;
      });

      var mediaItem = MediaItem(
        id: widget._guidePoint.id.toString(),
        album: widget._guidePoint.name,
        title: widget._guidePoint.name,
        artUri: Uri.parse(widget._guidePoint.image),
      );

      String url = await firebaseStorage.child(widget._guidePoint.audio).getDownloadURL() ?? "";

      Log.show("The URL is: $url");

      var duration = await _player.setAudioSource(AudioSource.uri(
          Uri.parse(url),
          tag: mediaItem));

      _audioDuration = duration;
      _listenToPositionUpdates();
      _listenPlayerUpdates();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading audio: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return "00:00";

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes);
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    double currentPositionSeconds = _currentPosition?.inSeconds.toDouble() ?? 0.0;
    double totalDurationSeconds = _audioDuration?.inSeconds.toDouble() ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSizes.marginSmall),
      decoration: const BoxDecoration(
          color: AppColors.lightGrey, borderRadius: BorderRadius.all(Radius.circular(AppSizes.radius))),
      width: double.infinity,
      height: AppSizes.audioPlayerHeight,
      child: Row(
        children: [
          Text(
            _formatDuration(_currentPosition),
            style: const TextStyle(color: AppColors.primary, fontSize: AppSizes.fontSmall),
          ),
          Text(
            "/${_formatDuration(_audioDuration)}",
            style: const TextStyle(color: AppColors.subtitle, fontSize: AppSizes.fontSmall),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 1.0,
                inactiveTrackColor: AppColors.subtitle,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: AppSizes.audioPlayerThumbShape),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: AppSizes.audioPlayerThumbShape),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.marginSmall),
                child: Slider(
                  min: 0,
                  max: totalDurationSeconds,
                  value: currentPositionSeconds.clamp(0, totalDurationSeconds),
                  onChanged: (value) {
                    setState(() {
                      _currentPosition = Duration(seconds: value.toInt());
                    });
                    _player.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
            ),
          ),
          InkWell(
              onTap: () async {
                if (_isLoading) return;

                if (_isPlaying) {
                  await _player.pause();
                } else {
                  await _player.play();
                }
              },
              child: _isLoading
                  ? const SizedBox(
                      width: AppSizes.audioIconButton,
                      height: AppSizes.audioIconButton,
                      child: CircularProgressIndicator(color: AppColors.primary))
                  : _isPlaying
                      ? const Icon(AppIcons.ic_pause, color: AppColors.primary, size: AppSizes.audioIconButton)
                      : const Icon(AppIcons.ic_play, color: AppColors.primary, size: AppSizes.audioIconButton))
        ],
      ),
    );
  }
}
