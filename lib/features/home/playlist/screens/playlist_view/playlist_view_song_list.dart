// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/widgets/loading.dart';
import 'package:anysongs/core/widgets/song_tile.dart';
import 'package:anysongs/features/home/playlist/data/playlist_manager.dart';
import 'package:anysongs/features/home/playlist/models/playlist_data.dart';
import 'package:flutter/material.dart';

class PlaylistViewSongList extends StatelessWidget {
  final PlaylistItem playlist;
  const PlaylistViewSongList({
    super.key,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    final thumbSize = context.defaultThumbSize;
    return FutureBuilder(
      future: PlaylistManager().getAllSongsOfPlaylist(playlist.playlistId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(child: Loading());
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: ErrorWidget(snapshot.error!),
          );
        } else {
          final list = snapshot.data!;
          return SliverList.builder(
            itemBuilder: (context, index) {
              final song = list[index];
              return song == null
                  ? const SizedBox.shrink()
                  : SongTile(
                      song: song,
                      isCurrentSong: false,
                      thumbSize: thumbSize,
                      onTap: () {});
            },
            itemCount: list.length,
          );
        }
      },
    );
  }
}
