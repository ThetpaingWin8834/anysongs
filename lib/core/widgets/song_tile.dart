// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/utils/debug.dart';
import 'package:anysongs/core/widgets/my_artwork_widget.dart';
import 'package:flutter/material.dart';

import '../models/song.dart';

///

class SongTile extends StatelessWidget {
  final Song song;
  final bool isCurrentSong;
  final double thumbSize;
  final VoidCallback onTap;
  const SongTile({
    super.key,
    required this.song,
    required this.isCurrentSong,
    required this.thumbSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    mp(thumbSize);
    return ListTile(
      dense: true,
      onTap: onTap,
      leading: MyArtWorkWidget2(
        uri: song.thumb,
        width: thumbSize,
        height: thumbSize,
        fit: BoxFit.fill,
        borderRadius: BorderRadius.circular(thumbSize),
      ),
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
