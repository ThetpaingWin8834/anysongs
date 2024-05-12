part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeScreenChangeState extends HomeState {
  final HomeScreenType screenType;

  HomeScreenChangeState(this.screenType);
}

@immutable
sealed class HomeAllLocalSongsState extends HomeState {}

final class HomeFetchingLocalSongs extends HomeAllLocalSongsState {}

final class HomeSongChange extends HomeState {}

final class HomeGotLocalSongs extends HomeAllLocalSongsState {
  final List<SongModel> songs;

  HomeGotLocalSongs(this.songs);
}

final class HomeLocalError extends HomeAllLocalSongsState {
  final Object? error;

  HomeLocalError(this.error);
}

@immutable
sealed class HomePlayListState extends HomeState {}

final class HomeFetchingPlaylist extends HomePlayListState {}

final class HomePlaylists extends HomePlayListState {
  final List<PlaylistModel> playlists;

  HomePlaylists(this.playlists);
}

@immutable
sealed class HomeAlbumState extends HomeState {}

final class HomeFetchingAlbum extends HomeAlbumState {}

final class HomeAlbum extends HomeAlbumState {
  final List<AlbumModel> albums;

  HomeAlbum(this.albums);
}

@immutable
sealed class FavoriteState extends HomeState {}

final class AllFavSongs extends FavoriteState {
  final List<SongModel> songs;

  AllFavSongs(this.songs);
}
