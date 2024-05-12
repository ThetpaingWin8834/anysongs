// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/core/models/song.dart';
import 'package:anysongs/core/player/player_manager.dart';
import 'package:anysongs/features/home/data/favorite_repo.dart';
import 'package:anysongs/features/home/data/repository/local_songs_repo.dart';
import 'package:anysongs/features/home/domain/models/home_screen_type.dart';
import 'package:anysongs/features/home/domain/repository/local_songs_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(HomeScreenChangeState(HomeScreenType.all)) {
    _playerManager.currentSong.listen((song) {
      emit(HomeSongChange());
    });
  }
  late final OnAudioQuery onAudioQuery = OnAudioQuery();
  late final LocalSongsRepo localSongsRepo = LocalSongsRepoImpl(onAudioQuery);
  late final PlayerManager _playerManager = PlayerManager();
  late final FavoriteRepo favRepo = FavoriteRepo();

  BehaviorSubject<Song?> get currentSong => _playerManager.currentSong;
  BehaviorSubject<bool> get isPlaying => _playerManager.isPlaying;

  BehaviorSubject<List<SongModel>> favoriteSongs = BehaviorSubject();

  // final Map<String, Uri> artworksUri = {};
  // final Map<String, Uint8List?> artworks = {};

  // void getAllLocalSongs() async {
  //   try {
  //     await favRepo.initDb();
  //     emit(HomeFetchingLocalSongs());
  //     final songs = await localSongsRepo.getAllLocalSongs();
  //     allSongs.clear();
  //     allSongs.addAll(songs);
  //     await getAllFavSongs(songs);
  //     emit(
  //       HomeGotLocalSongs(
  //         songs,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(HomeLocalError(e));
  //   }
  // }

  // String uint8ListToDataUri(Uint8List uint8List) {
  //   final base64String = base64Encode(uint8List);
  //   return 'data:image/jpeg;base64,$base64String';
  // }

  // final List<SongModel> allSongs = [];

  // void playSongs(List<SongModel> songs, SongModel playSong) {
  //   // _playerManager.playAll(songs, playSong);
  // }

  // void toggleSong() => _playerManager.toggleSong();
  // void skipNext() {
  //   _playerManager.skipNext();
  //   if (!_playerManager.audioPlayer.playing) {
  //     _playerManager.audioPlayer.play();
  //   }
  // }

  // void skipPrev() {
  //   _playerManager.skipPrevious();
  //   if (!_playerManager.audioPlayer.playing) {
  //     _playerManager.audioPlayer.play();
  //   }
  // }

  // void changeHomeScreenType(HomeScreenType type) {
  //   emit(
  //     HomeScreenChangeState(type),
  //   );
  // }

  // void getAllPlaylist() async {
  //   final playlists = await localSongsRepo.getPlaylists();
  //   emit(HomePlaylists(playlists));
  // }

  // void getAllAlbum() async {
  //   final albums = await localSongsRepo.getAlbums();
  //   emit(HomeAlbum(albums));
  // }

  // Future<bool> deletePlayList(int id) async {
  //   return await localSongsRepo.deletePlayList(id);
  // }

  // Future<void> getAllFavSongs(List<SongModel> songs) async {
  //   final favIds = await favRepo.getAllSongsId();
  //   favoriteSongs.value =
  //       songs.where((song) => favIds.contains(song.id)).toList();
  // }

  // Future<void> addFavSongs(List<SongModel> songs, SongModel song) async {
  //   mp('adding');
  //   await favRepo.saveSong(song.id);
  //   await getAllFavSongs(songs);
  // }

  // void removeFavSongs(List<SongModel> songs, SongModel song) async {
  //   await favRepo.removeSong(song.id);
  //   await getAllFavSongs(songs);
  // }

  // void onFavClick(bool addFav, List<SongModel> songs, SongModel song) {
  //   if (addFav) {
  //     addFavSongs(songs, song);
  //   } else {
  //     removeFavSongs(songs, song);
  //   }
  // }
  // void initArtworkAndUri(List<Song> songs) async {
  //   if (songs.length == artworks.length && songs.length == artworksUri.length) {
  //     return;
  //   }
  //   for (final song in songs) {
  //     final bytes = await localSongsRepo.getArtwork(
  //         int.parse(song.id), ArtworkType.AUDIO);
  //     artworks[song.id] = bytes;
  //     Directory tempDir = await getApplicationSupportDirectory();
  //     var path = tempDir.path;
  //     var filePath = "$path/${song.id}.png";
  //     var file = await File(filePath).writeAsBytes(bytes!);
  //     artworksUri[song.id] = file.uri;
  //   }
  // }

  // Future<Uint8List?> getArtWorkFrom(String id, ArtworkType type) async {
  //   artworks[id] ??= await localSongsRepo.getArtwork(int.parse(id), type);

  //   return artworks[id];
  // }

  // Future<Uri?> getUri(Uint8List? bytes, String id) async {
  //   if (bytes == null) return null;
  //   if (!artworksUri.containsKey(id)) {
  //     Directory tempDir = await getApplicationSupportDirectory();
  //     var path = tempDir.path;
  //     var filePath = "$path/$id.png";
  //     var file = await File(filePath).writeAsBytes(bytes);
  //     artworksUri[id] = file.uri;
  //   }

  //   return artworksUri[id];
  // }
}
