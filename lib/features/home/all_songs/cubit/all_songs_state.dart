part of 'all_songs_cubit.dart';

@immutable
sealed class AllSongsState {}

final class AllSongsInitial extends AllSongsState {}

final class AllSongsLoading extends AllSongsState {}

final class AllSongsError extends AllSongsState {
  final Object? error;
  AllSongsError({required this.error});
}

final class AllSongsEmpty extends AllSongsState {}

final class AllSongsLoaded extends AllSongsState {
  final List<Song> songs;
  AllSongsLoaded({required this.songs});
}
