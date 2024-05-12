import 'package:just_audio/just_audio.dart';

extension AudioPlayerExts on AudioPlayer {
  Future<void> toggle() async {
    return playing ? pause() : play();
  }
}
