import 'package:anysongs/core/extensions/on_audio_query_exts.dart';
import 'package:anysongs/core/models/song.dart';
import 'package:anysongs/core/player/player_manager.dart';
import 'package:anysongs/features/home/all_songs/data/local_songs_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'all_songs_state.dart';

class AllSongsCubit extends Cubit<AllSongsState> {
  AllSongsCubit() : super(AllSongsInitial());
  final localSongsRepo = LocalSongsRepository();
  final playerManager = PlayerManager();

  BehaviorSubject<Song?> get currentSong => playerManager.currentSong;

  void getAllSongs() async {
    try {
      emit(AllSongsLoading());
      final list = await localSongsRepo.getAllLocalSongs();
      final songs = <Song>[];
      for (var i = 0; i < list.length; i++) {
        final songModel = list[i];
        final uri = await localSongsRepo.onAudioQuery.getThumb(songModel);
        songs.add(Song.fromSongModel(songModel, uri));
      }
      if (songs.isEmpty) {
        emit(AllSongsEmpty());
      } else {
        emit(AllSongsLoaded(songs: songs));
      }
    } catch (e) {
      emit(AllSongsError(error: e));
    }
  }

  void onSongClick(List<Song> songs, Song song) {
    playerManager.playAll(songs, song);
  }
}
