import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/locale/locale.dart';
import 'package:anysongs/core/models/state.dart';
import 'package:anysongs/core/player/player_manager.dart';
import 'package:anysongs/core/utils/debug.dart';
import 'package:anysongs/core/widgets/shuffle_tile.dart';
import 'package:anysongs/features/home/all_songs/cubit/all_songs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      onRefresh: () {
        context.showLoadingDialog();
        mp(ModalRoute.of(context)?.settings.name);
        allSongsBloc.getAllSongs().then((_) {});
        return Future.delayed(Duration.zero);
      },
      child: BlocBuilder<AllSongsCubit, MyState<List<Song>>>(
        builder: (context, state) {
          return switch (state) {
            SuccessState<List<Song>> songs => LocalSongsList(
                songs: songs.data,
              ),
            ErrorState error => MyError(
                error: error.error,
              ),
            LoadingState _ => const Loading(),
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
  const LocalSongsList({
    super.key,
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    const thumbSize = 50.0;
    final playerManager = PlayerManager();
    return StreamBuilder(
      stream: playerManager.currentSong,
      builder: (context, snapshot) => Column(
        children: [
          ShuffleTile(
            onShuffleClick: () {
              playerManager.onShuffleClick(songs);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return SongTile(
                  song: song,
                  isCurrentSong: snapshot.data?.id == song.id,
                  thumbSize: thumbSize,
                  onTap: () {
                    playerManager.playAll(songs, song);
                  },
                );
              },
            ),
          ),
        ],
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