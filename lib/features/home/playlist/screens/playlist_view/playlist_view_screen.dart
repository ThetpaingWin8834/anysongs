// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/features/home/playlist/models/playlist_data.dart';
import 'package:anysongs/features/home/playlist/screens/playlist_view/playlist_sliver_appbar.dart';
import 'package:anysongs/features/home/playlist/screens/playlist_view/playlist_view_song_list.dart';
import 'package:flutter/material.dart';

class PlaylistViewScreen extends StatelessWidget {
  final PlaylistItem playlist;
  const PlaylistViewScreen({
    super.key,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          PlaylistSliverAppbar(playlist: playlist),
          PlaylistViewSongList(playlist: playlist)
        ],
      ),
    );
  }
}
