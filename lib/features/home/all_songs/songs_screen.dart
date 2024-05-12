// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/locale/locale.dart';
import 'package:anysongs/features/home/all_songs/cubit/all_songs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../core/models/song.dart';
import '../../../core/widgets/error.dart';
import '../../../core/widgets/loading.dart';
import '../../../core/widgets/song_tile.dart';

class AllLocalSongsScreen extends StatefulWidget {
  const AllLocalSongsScreen({super.key});

  @override
  State<AllLocalSongsScreen> createState() => _AllLocalSongsScreenState();
}

class _AllLocalSongsScreenState extends State<AllLocalSongsScreen>
    with AutomaticKeepAliveClientMixin {
  late final allSongsBloc = context.read<AllSongsCubit>();
  @override
  void initState() {
    allSongsBloc.getAllSongs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        allSongsBloc.getAllSongs();
        await Future.delayed(const Duration(seconds: 2));
      },
      child: BlocBuilder<AllSongsCubit, AllSongsState>(
        builder: (context, state) {
          return switch (state) {
            AllSongsLoaded songs => LocalSongsList(
                songs: songs.songs,
                bloc: allSongsBloc,
              ),
            AllSongsError error => MyError(
                error: error.error,
              ),
            AllSongsEmpty _ => const EmptySongs(),
            AllSongsLoading _ => const Loading(),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class EmptySongs extends StatelessWidget {
  const EmptySongs({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(Mylocale.noSongs),
    );
  }
}

class LocalSongsList extends StatelessWidget {
  final List<Song> songs;
  final AllSongsCubit bloc;
  const LocalSongsList({
    Key? key,
    required this.songs,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = OnAudioQuery();
    late final thumbSize = context.percentWidthOf(0.2);

    return StreamBuilder(
      stream: bloc.currentSong,
      builder: (context, snapshot) => ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return SongTile(
            controller: controller,
            song: song,
            isCurrentSong: snapshot.data?.id == song.id,
            thumbSize: thumbSize,
            onTap: () {
              bloc.onSongClick(songs, song);
            },
          );
        },
      ),
    );
  }
}

/**
 * 
 * switch (state) {
            HomeGotLocalSongs localSongs => localSongs.songs.isNotEmpty
                ? MyStreamWidget(
                    stream: homeBloc.currentSong.combineLatest(
                        homeBloc.favoriteSongs,
                        (curSong, favs) => (curSong, favs)),
                    child: (pair) {
                      final currentSong = pair.$1;
                      final favList = pair.$2;
                      return ListView.builder(
                        itemCount: localSongs.songs.length,
                        itemBuilder: (context, index) {
                          final song = localSongs.songs[index];
                          return SongTile(
                            controller: homeBloc.onAudioQuery,
                            song: song,
                            isCurrentSong: currentSong?.id == song.id,
                            isFavorite: favList.contains(song),
                            onFavClick: (addFav) {
                              homeBloc.onFavClick(
                                  addFav, localSongs.songs, song);
                            },
                            thumbSize: thumbSize,
                            onTap: () {
                              context.navigateToScreen(
                                const SongControlScreen(),
                              );
                              homeBloc.playSongs(localSongs.songs, song);
                            },
                          );
                        },
                      );
                    },
                  )
                : Center(
                    child: Text(Mylocale.noSongs),
                  ),
            HomeLocalError error => MyError(
                error: error.error,
              ),
            HomeFetchingLocalSongs _ => const Loading(),
            _ => const SizedBox.shrink(),
          };
 */