import 'package:anysongs/core/extensions/on_audio_query_exts.dart';
import 'package:anysongs/core/models/song.dart';
import 'package:anysongs/core/models/state.dart';
import 'package:anysongs/core/player/player_manager.dart';
import 'package:anysongs/features/home/all_songs/data/local_songs_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class AllSongsCubit extends Cubit<MyState<List<Song>>> {
  AllSongsCubit() : super(InitialState());
  final localSongsRepo = LocalSongsRepository();
  final playerManager = PlayerManager();

  BehaviorSubject<Song?> get currentSong => playerManager.currentSong;

  Future<void> getAllSongs() async {
    try {
      if (state is! SuccessState ||
          (state as SuccessState<List<Song>>).data.isEmpty) {
        emit(LoadingState());
      }
      final list = await localSongsRepo.getAllLocalSongs();
      final songs = <Song>[];
      for (var i = 0; i < list.length; i++) {
        final songModel = list[i];
        final uri = await localSongsRepo.onAudioQuery.getThumb(songModel);
        songs.add(Song.fromSongModel(songModel, uri));
      }
      emit(SuccessState(data: songs));
    } catch (e) {
      emit(ErrorState(error: e));
    }
  }

  void onSongClick(List<Song> songs, Song song) {
    playerManager.playAll(songs, song);
  }
}
