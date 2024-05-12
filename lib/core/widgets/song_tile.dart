// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/widgets/my_artwork_widget.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../models/song.dart';

///

class SongTile extends StatelessWidget {
  final Song song;
  final bool isCurrentSong;
  final double thumbSize;
  final OnAudioQuery? controller;
  final VoidCallback onTap;
  const SongTile({
    Key? key,
    required this.song,
    required this.isCurrentSong,
    required this.thumbSize,
    this.controller,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onTap,
      leading: MyArtWorkWidget2(uri: song.thumb),
      title: Text(
        song.title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: isCurrentSong
            ? TextStyle(color: context.colorScheme.primary)
            : null,
      ),
      subtitle: Text("${song.artist ?? ''} • ${song.duration}"),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert_rounded),
      ),
    );
  }
}

/**
 * QueryArtworkWidget(
        keepOldArtwork: true,
        id: song.id,
        type: ArtworkType.AUDIO,
        controller: controller,
        nullArtworkWidget: Image.asset(
          MyImages.appLogo,
          width: 50,
          height: 50,
        ),
      )
 */
