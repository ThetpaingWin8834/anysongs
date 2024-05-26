import 'package:anysongs/core/extensions/audio_player_exts.dart';
import 'package:anysongs/core/extensions/list_exts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

import '../models/song.dart';

typedef _PlaylistIdentifier = ({
  int length,
  String startId,
  String middleId,
  String endId
});

class PlayerManager {
  late final AudioPlayer audioPlayer = AudioPlayer();
  static PlayerManager? instance;
  PlayerManager._internal() {
    audioPlayer.currentIndexStream.listen((index) {
      final song = index == null && _currentPlayList == null
          ? null
          : _currentPlayList![index!];
      currentSong.add(song);
    });
    audioPlayer.playingStream.listen((playing) {
      isPlaying.add(playing);
    });
  }

  _PlaylistIdentifier _identifier =
      (length: 0, startId: '0', middleId: '0', endId: '0');

  factory PlayerManager() {
    instance ??= PlayerManager._internal();
    return instance!;
  }
  List<Song>? _currentPlayList;

  late final BehaviorSubject<Song?> currentSong = BehaviorSubject.seeded(null);
  late final BehaviorSubject<bool> isPlaying = BehaviorSubject();

  void playAll(
    List<Song> songs,
    Song playSong,
  ) async {
    final isChanged = await didChangePlaylist(songs);
    if (isChanged) {
      await initPlayList(songs);
    }
    final index = songs.indexOf(playSong);
    if (audioPlayer.currentIndex == index) {
      audioPlayer.toggle();
    } else {
      audioPlayer.seek(Duration.zero, index: index);
      audioPlayer.play();
    }
  }

  void onShuffleClick(
    List<Song> songs,
  ) async {
    final isChanged = await didChangePlaylist(songs);
    if (isChanged) {
      await initPlayList(songs);
    }

    // await audioPlayer.shuffle();
    await audioPlayer.setShuffleModeEnabled(true);
    audioPlayer.play();
  }

  void toggleSong() => audioPlayer.toggle();
  void skipNext() {
    audioPlayer.seekToNext();
    if (!audioPlayer.playing) {
      audioPlayer.play();
    }
  }

  void skipPrevious() {
    audioPlayer.seekToPrevious();
    if (!audioPlayer.playing) {
      audioPlayer.play();
    }
  }

  void seekTo(double seconds) {
    audioPlayer.seek(Duration(seconds: seconds.floor()));
  }

  void setShuffleMode(bool value) {
    audioPlayer.setShuffleModeEnabled(value);
  }

  Future<void> initPlayList(List<Song> songs) async {
    _identifier = (
      length: songs.length,
      startId: songs.first.id,
      middleId: songs[songs.middleIndex].id,
      endId: songs.last.id
    );
    _currentPlayList = songs;
    await audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: songs
            .map(
              (song) => AudioSource.uri(
                Uri.parse(song.uri!),
                tag: MediaItem(
                    id: song.id.toString(),
                    title: song.title,
                    artUri: song.thumb),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<bool> didChangePlaylist(List<Song> songs) async {
    return songs.length != _identifier.length ||
        songs.first.id != _identifier.startId ||
        songs.middle.id != _identifier.middleId ||
        songs.last.id != _identifier.endId;
  }
}
