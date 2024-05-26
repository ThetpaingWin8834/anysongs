// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:anysongs/core/extensions/context_exts.dart';
import 'package:anysongs/core/extensions/duration_exts.dart';
import 'package:anysongs/core/models/song.dart';
import 'package:anysongs/core/player/player_manager.dart';
import 'package:anysongs/core/widgets/custom_stream.dart';
import 'package:anysongs/core/widgets/my_artwork_widget.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:palette_generator/palette_generator.dart';

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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              // flex: 4,
              child: MyStreamWidget(
                stream: playerManager.currentSong,
                child: (currentSong) {
                  return ControlHeader(
                    song: currentSong!,
                    paletteColor: _paletteColor,
                  );
                },
              ),
            ),
            ControlSlider(
                playerManager: playerManager, paletteColor: _paletteColor),
            MediaControl(
              playerManager: playerManager,
              paletteColor: _paletteColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  Widget body() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        child: MyStreamWidget(
            stream: playerManager.currentSong,
            child: (song) {
              return Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: MyArtWorkWidget2(
                      uri: song!.thumb,
                      width: context.percentWidthOf(0.7),
                      height: context.percentWidthOf(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        song.title,
                        style: context.textTheme.titleMedium
                            ?.copyWith(color: _paletteColor?.titleTextColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                  Flexible(
                    flex: 2,
                    child: MyStreamWidget(
                      stream: playerManager.audioPlayer.createPositionStream(),
                      child: (duration) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(7),
                              child: Text(
                                duration.formatAsSongDuration,
                                style: context.textTheme.bodyMedium?.copyWith(
                                    color: _paletteColor?.bodyTextColor),
                              ),
                            ),
                            Expanded(
                                child: Slider(
                              value: duration.inSeconds.toDouble(),
                              max: playerManager.audioPlayer.duration?.inSeconds
                                      .toDouble() ??
                                  60.0,
                              onChanged: playerManager.seekTo,
                              inactiveColor: _paletteColor?.titleTextColor
                                  .withOpacity(0.2),
                              activeColor: _paletteColor?.bodyTextColor,
                            )),
                            Padding(
                              padding: const EdgeInsets.all(7),
                              child: Text(
                                playerManager.audioPlayer.duration
                                        ?.formatAsSongDuration ??
                                    "",
                                style: context.textTheme.bodyMedium?.copyWith(
                                    color: _paletteColor?.bodyTextColor),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyStreamWidget(
                          stream: playerManager
                              .audioPlayer.shuffleModeEnabledStream,
                          child: (isShuffle) => IconButton(
                            onPressed: () =>
                                playerManager.setShuffleMode(!isShuffle),
                            icon: Icon(
                              Icons.shuffle_rounded,
                              size: 30,
                              color: isShuffle
                                  ? _paletteColor?.titleTextColor
                                  : _paletteColor?.titleTextColor
                                      .withOpacity(0.2),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: playerManager.skipPrevious,
                          icon: Icon(
                            Icons.skip_previous_rounded,
                            size: 30,
                            color: _paletteColor?.titleTextColor,
                          ),
                        ),
                        MyStreamWidget(
                          stream: playerManager.isPlaying,
                          child: (isPlaying) => IconButton(
                              onPressed: playerManager.toggleSong,
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_circle_filled_rounded
                                    : Icons.play_circle_filled_rounded,
                                size: 50,
                                color: _paletteColor?.titleTextColor,
                              )),
                        ),
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
                  )
                ],
              );
            }),
      );
}

class MediaControl extends StatelessWidget {
  final PlayerManager playerManager;
  final PaletteColor? paletteColor;
  const MediaControl({
    Key? key,
    required this.playerManager,
    this.paletteColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MyStreamWidget(
          stream: playerManager.audioPlayer.shuffleModeEnabledStream,
          child: (isShuffle) => IconButton(
            onPressed: () => playerManager.setShuffleMode(!isShuffle),
            icon: Icon(
              Icons.shuffle_rounded,
              size: 30,
              color: isShuffle
                  ? context.colorScheme.primary
                  : paletteColor?.titleTextColor,
            ),
          ),
        ),
        IconButton(
          onPressed: playerManager.skipPrevious,
          icon: Icon(
            Icons.skip_previous_rounded,
            size: 30,
            color: paletteColor?.titleTextColor,
          ),
        ),
        MyStreamWidget(
          stream: playerManager.isPlaying,
          child: (isPlaying) => IconButton(
              onPressed: playerManager.toggleSong,
              icon: Icon(
                isPlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.play_circle_filled_rounded,
                size: 50,
                color: paletteColor?.titleTextColor,
              )),
        ),
        IconButton(
          onPressed: playerManager.skipNext,
          icon: Icon(
            Icons.skip_next_rounded,
            size: 30,
            color: paletteColor?.titleTextColor,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite_outline_rounded,
            size: 30,
            color: paletteColor?.titleTextColor,
          ),
        ),
      ],
    );
  }
}

class ControlSlider extends StatelessWidget {
  final PlayerManager playerManager;
  final PaletteColor? paletteColor;
  const ControlSlider({
    Key? key,
    required this.playerManager,
    required this.paletteColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyStreamWidget(
      stream: playerManager.audioPlayer.createPositionStream(),
      child: (duration) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(7),
              child: Text(
                duration.formatAsSongDuration,
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: paletteColor?.bodyTextColor),
              ),
            ),
            Expanded(
                child: Slider(
              value: duration.inSeconds.toDouble(),
              max: playerManager.audioPlayer.duration?.inSeconds.toDouble() ??
                  60.0,
              onChanged: playerManager.seekTo,
              inactiveColor: paletteColor?.titleTextColor.withOpacity(0.2),
              activeColor: paletteColor?.bodyTextColor,
            )),
            Padding(
              padding: const EdgeInsets.all(7),
              child: Text(
                playerManager.audioPlayer.duration?.formatAsSongDuration ?? "",
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: paletteColor?.bodyTextColor),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ControlHeader extends StatelessWidget {
  final Song song;
  final PaletteColor? paletteColor;
  const ControlHeader({
    Key? key,
    required this.song,
    this.paletteColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 1,
              child: MyArtWorkWidget2(
                uri: song.thumb,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: SizedBox(
            width: double.maxFinite,
            height: 30,
            child: Marquee(
              text: song.title,
              velocity: 30,
              style: context.textTheme.titleMedium
                  ?.copyWith(color: paletteColor?.titleTextColor),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            song.artist ?? '',
            style: context.textTheme.bodyMedium
                ?.copyWith(color: paletteColor?.bodyTextColor),
            maxLines: 1,
          ),
        ),
      ],
    );
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
