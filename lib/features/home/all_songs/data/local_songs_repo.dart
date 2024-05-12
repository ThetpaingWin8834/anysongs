import 'dart:typed_data';

import 'package:on_audio_query/on_audio_query.dart';

class LocalSongsRepository {
  final OnAudioQuery onAudioQuery = OnAudioQuery();
  Future<List<SongModel>> getAllLocalSongs() async {
    return await onAudioQuery.querySongs();
  }

  Future<List<AlbumModel>> getAlbums() async {
    return await onAudioQuery.queryAlbums();
  }

  Future<List<PlaylistModel>> getPlaylists() async {
    return await onAudioQuery.queryPlaylists();
  }

  Future<Uint8List?> getArtwork(int id, ArtworkType type) {
    return onAudioQuery.queryArtwork(id, type);
  }

  Future<bool> createNewPlayList(String name) async {
    return await onAudioQuery.createPlaylist(name);
  }

  Future<bool> deletePlayList(int id) async {
    return await onAudioQuery.removePlaylist(id);
  }
}
