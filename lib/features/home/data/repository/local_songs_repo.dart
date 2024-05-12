import 'dart:typed_data';

import 'package:anysongs/features/home/domain/repository/local_songs_repo.dart';
import 'package:on_audio_query/on_audio_query.dart';

class LocalSongsRepoImpl implements LocalSongsRepo {
  final OnAudioQuery onAudioQuery;

  LocalSongsRepoImpl(this.onAudioQuery);
  @override
  Future<List<SongModel>> getAllLocalSongs() async {
    return await onAudioQuery.querySongs();
  }

  @override
  Future<List<AlbumModel>> getAlbums() async {
    return await onAudioQuery.queryAlbums();
  }

  @override
  Future<List<PlaylistModel>> getPlaylists() async {
    return await onAudioQuery.queryPlaylists();
  }

  @override
  Future<Uint8List?> getArtwork(int id, ArtworkType type) {
    return onAudioQuery.queryArtwork(id, type);
  }

  @override
  Future<bool> createNewPlayList(String name) async {
    return await onAudioQuery.createPlaylist(name);
  }

  @override
  Future<bool> deletePlayList(int id) async {
    return await onAudioQuery.removePlaylist(id);
  }
}
