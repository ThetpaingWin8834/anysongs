import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/locale/locale.dart';
import 'package:anysongs/core/player/player_manager.dart';
import 'package:anysongs/core/widgets/my_artwork_widget.dart';
import 'package:anysongs/core/widgets/rotating_widget.dart';
import 'package:anysongs/features/home/album/album_screen.dart';
import 'package:anysongs/features/home/all_songs/songs_screen.dart';
import 'package:anysongs/features/home/favorite/fav_screen.dart';
import 'package:anysongs/features/playlist/playlist_screen.dart';
import 'package:anysongs/features/song_control/song_control_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_transform/stream_transform.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final TabController tabController = TabController(length: 4, vsync: this);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Mylocale.appName,
        ),
      ),
      body: Column(
        children: [
          TabBar(
            isScrollable: true,
            controller: tabController,
            tabs: [
              Tab(
                child: Text(Mylocale.songs),
              ),
              Tab(
                child: Text(Mylocale.favorites),
              ),
              Tab(
                child: Text(Mylocale.playlists),
              ),
              Tab(
                child: Text(Mylocale.albums),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(controller: tabController, children: const [
              AllLocalSongsScreen(),
              FavScreen(),
              PlaylistScreen(),
              AlbumScreen(),
            ]),
          ),
          const SongControlBar(),
        ],
      ),
    );
  }
}

class SongControlBar extends StatefulWidget {
  const SongControlBar({super.key});

  @override
  State<SongControlBar> createState() => _SongControlBarState();
}

class _SongControlBarState extends State<SongControlBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 6));
  // late final homeBloc = context.read<HomeBloc>();
  final playerManager = PlayerManager();
  @override
  void initState() {
    super.initState();
    // homeBloc.currentSong.listen((_) {
    //   setState(() {});
    // });
    playerManager.isPlaying.listen((playing) {
      setState(() {});
      if (playing) {
        animationController.repeat();
      } else {
        animationController.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final song = homeBloc.currentSong.value;
    // if (song == null) return const SizedBox.shrink();
    // final isPlaying = homeBloc.isPlaying.value;
    return StreamBuilder(
        stream: playerManager.currentSong.combineLatest(
            playerManager.isPlaying, (song, playing) => (song, playing)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          final currentPlayingSong = snapshot.data!.$1;
          final isPlaying = snapshot.data!.$2;
          if (currentPlayingSong == null) {
            return const SizedBox.shrink();
          }
          return InkWell(
            onTap: () {
              context.navigateToScreen(
                const SongControlScreen(),
              );
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: MyRotatingWidget(
                    animationController: animationController,
                    child: Hero(
                      tag: currentPlayingSong,
                      child: MyArtWorkWidget2(uri: currentPlayingSong.thumb),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 3),
                          child: Text(
                            currentPlayingSong.title,
                            style: context.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      if (currentPlayingSong.artist != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            currentPlayingSong.artist!,
                            style: context.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: playerManager.skipPrevious,
                  icon: const Icon(
                    Icons.skip_previous_rounded,
                  ),
                ),
                IconButton(
                  onPressed: playerManager.toggleSong,
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                ),
                IconButton(
                  onPressed: playerManager.skipNext,
                  icon: const Icon(
                    Icons.skip_next_rounded,
                  ),
                ),
              ],
            ),
          );
        });
  }
}