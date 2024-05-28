import 'package:anysongs/core/utils/debug.dart';
import 'package:anysongs/features/home/playlist/models/playlist_data.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/models/song.dart';

class PlaylistManager {
  final databaseName = "anysongs_playlist.db";
  final playlistItemTableName = "PlaylistItem";
  final songsOfPlaylist = "SongsOfPlaylist";
  late final Database database;
  bool _isDatabaseInitialized = false;
  Future<void> initiDb() async {
    if (_isDatabaseInitialized) return;
    database = await openDatabase(
      databaseName,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE $playlistItemTableName (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, firstThumbUri TEXT, count INTEGER)');

        await db.execute('''
CREATE TABLE $songsOfPlaylist (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  playlistId INTEGER,
  songId TEXT NOT NULL,
  title TEXT NOT NULL,
  thumb TEXT NOT NULL,
  artist TEXT,
  dateAdded INTEGER,
  duration TEXT,
  path TEXT NOT NULL
)
''');
      },
    );
    _isDatabaseInitialized = true;
  }

  Future<PlaylistData> getAllPlaylist() async {
    final result =
        await database.rawQuery('SELECT * FROM $playlistItemTableName');
    final playlistItems = result.map((e) => PlaylistItem.fromMap(e)).toList();
    for (final item in playlistItems) {
      final temp = await getAllSongsOfPlaylist(item.playlistId);
      mp(temp.length);
    }
    return PlaylistData(playlistItems: playlistItems);
  }

  Future<int> createNewPlaylist(String name) async {
    return await database.rawInsert(
        'INSERT INTO $playlistItemTableName (name, count) VALUES (?, 0)',
        [name]);
  }

  Future<void> getIdOfPlaylist(String name) async {
    final data = await database
        .rawQuery('SELECT id FROM $playlistItemTableName WHERE name = $name');
    mp(data);
  }

  Future<void> deletePlayList(int id) async {
    await database
        .rawDelete('DELETE FROM $playlistItemTableName WHERE id = $id');
    await deleteSongFromPlaylist(id);
    mp('deleted');
    final songs = await getAllSongsOfPlaylist(id);
    mp(songs.length);
  }

  Future<String> getPlaylistDatabasePath() async {
    final path = await getDatabasesPath();
    return '$path/$databaseName';
  }

  Future<void> updatePlaylistCountAndThumb(
      int id, int count, String thumbUri) async {
    await database.rawUpdate(
      'UPDATE $playlistItemTableName SET count = ?, firstThumbUri = ? WHERE id = $id',
      [count, thumbUri],
    );
  }

  Future<void> addListOfSongsToPlaylist(int id, List<Song> songs) async {
    for (final song in songs) {
      await addSongToPlaylist(id, song);
    }
    await updatePlaylistCountAndThumb(
        id, songs.length, songs.first.thumb.toString());
  }

  // Future<void> deleteAllSongs(int playlistId, List<Song> songs) async {
  //   await Future.wait(songs.map((e) => deleteSongFromPlaylist(playlistId, e)));
  // }

  Future<List<Song?>> getAllSongsOfPlaylist(int id) async {
    final result = await database
        .rawQuery('SELECT * FROM $songsOfPlaylist WHERE playlistId = $id');
    final songs = result.map((map) {
      try {
        return Song(
            id: map['songId'] as String,
            title: map['title'] as String,
            thumb: Uri.tryParse(map['thumb'] as String),
            artist: map['artist'] as String?,
            dateAdded: map['dateAdded'] as int?,
            duration: map['duration'] as String?,
            uri: map['path'] as String);
      } catch (e) {
        return null;
      }
    }).toList();
    return songs;
  }

  Future<void> deleteSongFromPlaylist(int id) async {
    await database
        .rawDelete('DELETE FROM $songsOfPlaylist WHERE playlistId = $id');
  }

  Future<void> addSongToPlaylist(int id, Song song) async {
    await database.rawInsert(
        'INSERT INTO $songsOfPlaylist (playlistId, songId, title, thumb, artist, dateAdded, duration, path) VALUES (?,?,?,?,?,?,?,?)',
        [
          id,
          song.id,
          song.title,
          song.thumb.toString(),
          song.artist,
          song.dateAdded,
          song.duration,
          song.uri
        ]);
  }
}
