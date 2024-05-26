import 'package:anysongs/core/models/state.dart';
import 'package:anysongs/core/utils/debug.dart';
import 'package:anysongs/features/home/playlist/data/playlist_manager.dart';
import 'package:anysongs/features/home/playlist/models/playlist_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/song.dart';

class PlaylistCubit extends Cubit<MyState<PlaylistData>> {
  PlaylistCubit() : super(InitialState());
  final PlaylistManager playlistManager = PlaylistManager();
  void getAllPlaylist() async {
    mp('calling');
    await playlistManager.initiDb();
    final result = await playlistManager.getAllPlaylist();
    mp(result);
    emit(SuccessState(data: result));
  }

  Future<int> createNewPlayList(String name) async {
    return await playlistManager.createNewPlaylist(name);
  }

  Future<void> deletePlayList(int id) async {
    return await playlistManager.deletePlayList(id);
  }

  Future<void> addListOfSongsToPlaylist(int id, List<Song> songs) async {
    return await playlistManager.addListOfSongsToPlaylist(id, songs);
  }
}
