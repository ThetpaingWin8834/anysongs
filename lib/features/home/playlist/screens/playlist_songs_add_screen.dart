// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/locale/locale.dart';
import 'package:anysongs/core/models/state.dart';
import 'package:anysongs/features/home/playlist/cubit/playlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/song.dart';
import '../../../../core/widgets/error.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../core/widgets/song_tile.dart';
import '../../all_songs/cubit/all_songs_cubit.dart';

class PlaylistSongsAddScreen extends StatefulWidget {
  final int playlistId;
  const PlaylistSongsAddScreen({
    super.key,
    required this.playlistId,
  });

  @override
  State<PlaylistSongsAddScreen> createState() => _PlaylistSongsAddScreenState();
}

class _PlaylistSongsAddScreenState extends State<PlaylistSongsAddScreen> {
  late final allSongsCubit = context.read<AllSongsCubit>();
  late final playlistCubit = context.read<PlaylistCubit>();
  final List<Song> selectedSongs = [];

  void toggleSong(Song song) {
    if (selectedSongs.contains(song)) {
      selectedSongs.remove(song);
    } else {
      selectedSongs.add(song);
    }
    setState(() {});
  }

  void toggleAddAll() {
    final list = (allSongsCubit.state as SuccessState<List<Song>>).data;
    if (selectedSongs.length == list.length) {
      selectedSongs.clear();
    } else {
      selectedSongs.clear();
      selectedSongs.addAll(list);
    }
    setState(() {});
  }

  void onAddClick() {
    playlistCubit
        .addListOfSongsToPlaylist(widget.playlistId, selectedSongs)
        .then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Mylocale.addSongs),
        actions: [
          if (selectedSongs.isNotEmpty)
            Stack(
              children: [
                IconButton.filledTonal(
                    onPressed: onAddClick, icon: const Icon(Icons.add)),
                Badge.count(count: selectedSongs.length)
              ],
            ),
          IconButton.filledTonal(
            onPressed: toggleAddAll,
            icon: const Icon(Icons.select_all),
          ),
        ],
      ),
      body: BlocBuilder<AllSongsCubit, MyState<List<Song>>>(
        builder: (context, state) {
          return switch (state) {
            SuccessState<List<Song>> songs => _SongList(
                list: songs.data,
                selectedSongs: selectedSongs,
                toggleSong: toggleSong,
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
}

class _SongList extends StatelessWidget {
  final List<Song> list;
  final List<Song> selectedSongs;
  final ValueSetter<Song> toggleSong;
  const _SongList({
    super.key,
    required this.list,
    required this.selectedSongs,
    required this.toggleSong,
  });

  @override
  Widget build(BuildContext context) {
    late final thumbSize = context.percentWidthOf(0.2);

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final song = list[index];
        return Container(
          margin: const EdgeInsets.all(2),
          color: selectedSongs.contains(song)
              ? context.colorScheme.primary.withOpacity(0.3)
              : null,
          child: SongTile(
            song: song,
            isCurrentSong: false,
            thumbSize: thumbSize,
            onTap: () {
              toggleSong(song);
            },
          ),
        );
      },
    );
  }
}
