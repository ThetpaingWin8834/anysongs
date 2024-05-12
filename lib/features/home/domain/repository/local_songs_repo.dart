import 'dart:typed_data';

import 'package:on_audio_query/on_audio_query.dart';

abstract interface class LocalSongsRepo {
  Future<List<SongModel>> getAllLocalSongs();
  Future<List<AlbumModel>> getAlbums();
  Future<List<PlaylistModel>> getPlaylists();
  Future<Uint8List?> getArtwork(int id, ArtworkType type);
  Future<bool> createNewPlayList(String name);
  Future<bool> deletePlayList(int id);
}
