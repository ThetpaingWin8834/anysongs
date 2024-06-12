// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/core/extensions/string_exts.dart';
import 'package:anysongs/core/widgets/blur/frost_widget.dart';
import 'package:anysongs/core/widgets/my_artwork_widget.dart';
import 'package:anysongs/features/home/playlist/models/playlist_data.dart';
import 'package:flutter/material.dart';

class PlaylistSliverAppbar extends StatelessWidget {
  final PlaylistItem playlist;
  const PlaylistSliverAppbar({
    super.key,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            MyArtWorkWidget2(
              width: double.maxFinite,
              height: double.maxFinite,
              fit: BoxFit.cover,
              uri: playlist.firstThumbUri?.asUri,
            ),
            FrostWidget(
              borderRadius: BorderRadius.zero,
              child: Center(
                child: MyArtWorkWidget2(
                  // width: 250,
                  // height: 100,
                  fit: BoxFit.cover,
                  uri: playlist.firstThumbUri?.asUri,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        ),
        title: Text(playlist.playlistName),
      ),
    );
  }
}
