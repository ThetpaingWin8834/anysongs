// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/models/song.dart';
import 'package:anysongs/core/player/player_manager.dart';
import 'package:anysongs/core/widgets/custom_stream.dart';
import 'package:anysongs/core/widgets/my_artwork_widget.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:stream_transform/stream_transform.dart';

class SongControlScreen extends StatefulWidget {
  const SongControlScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SongControlScreen> createState() => _SongControlScreenState();
}

class _SongControlScreenState extends State<SongControlScreen> {
  final playerManager = PlayerManager();
  PaletteColor? _paletteColor;

  @override
  void initState() {
    super.initState();
    playerManager.currentSong.listen((song) {
      generateColor(song);
    });
  }

  void generateColor(Song? song) async {
    if (song == null || song.thumb == null) return;
    final palette = await PaletteGenerator.fromImageProvider(
        FileImage(File.fromUri(song.thumb!)));
    _paletteColor = palette.darkMutedColor;
    // await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _paletteColor?.color,
      appBar: AppBar(
        backgroundColor: _paletteColor?.color,
        leading: BackButton(
          color: _paletteColor?.titleTextColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: MyStreamWidget(
            stream: playerManager.currentSong.combineLatest(
                playerManager.isPlaying,
                (song, playing) => (song: song, isPlaying: playing)),
            child: (pair) {
              final song = pair.song!;
              final isPlaying = pair.isPlaying;
              return Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: MyArtWorkWidget2(
                      uri: song.thumb,
                      width: context.percentWidthOf(0.8),
                      height: context.percentWidthOf(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      song.title,
                      style: context.textTheme.titleMedium
                          ?.copyWith(color: _paletteColor?.titleTextColor),
                    ),
                  ),
                  if (song.artist != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        song.artist!,
                        style: context.textTheme.bodyMedium
                            ?.copyWith(color: _paletteColor?.bodyTextColor),
                      ),
                    ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: playerManager.skipPrevious,
                            icon: Icon(
                              Icons.skip_previous_rounded,
                              size: 30,
                              color: _paletteColor?.titleTextColor,
                            ),
                          ),
                          IconButton(
                              onPressed: playerManager.toggleSong,
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_circle_filled_rounded
                                    : Icons.play_circle_filled_rounded,
                                size: 50,
                                color: _paletteColor?.titleTextColor,
                              )),
                          IconButton(
                            onPressed: playerManager.skipNext,
                            icon: Icon(
                              Icons.skip_next_rounded,
                              size: 30,
                              color: _paletteColor?.titleTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }
}

class PlayPauseIcon extends StatefulWidget {
  const PlayPauseIcon({super.key});

  @override
  State<PlayPauseIcon> createState() => _PlayPauseIconState();
}

class _PlayPauseIconState extends State<PlayPauseIcon>
    with SingleTickerProviderStateMixin {
  late final animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 200));
  final playerManager = PlayerManager();
  @override
  void initState() {
    playerManager.isPlaying.listen((plaing) {
      if (plaing) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        shape: const CircleBorder(),
        color: context.colorScheme.primaryContainer,
      ),
      child: IconButton(
        onPressed: playerManager.toggleSong,
        icon: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: animationController,
        ),
      ),
    );
  }
}
