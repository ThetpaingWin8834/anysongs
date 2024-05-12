part of 'home_cubit.dart';

@immutable
sealed class HomeEvent {}

final class HomeGetAllLocalSongsEvent extends HomeEvent {}

final class HomeGetPlaylistsEvent extends HomeEvent {}

final class HomeGetAlbumEvent extends HomeEvent {}

final class HomePlaySongsEvent extends HomeEvent {
  final List<SongModel> songs;
  final SongModel playSong;

  HomePlaySongsEvent({required this.songs, required this.playSong});
}

final class HomeScreenTypeChangeEvent extends HomeEvent {
  final HomeScreenType screenType;

  HomeScreenTypeChangeEvent(this.screenType);
}
