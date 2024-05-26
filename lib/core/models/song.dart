// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:anysongs/core/utils/others.dart';
import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart';

@immutable
class Song {
  final String id;
  final String title;
  final Uri? thumb;
  final String? artist;
  final int? dateAdded;
  final String? duration;
  final String uri;

  const Song({
    required this.id,
    required this.title,
    required this.thumb,
    required this.artist,
    required this.dateAdded,
    required this.duration,
    required this.uri,
  });

  factory Song.fromSongModel(SongModel model, Uri? thumb) => Song(
      id: model.id.toString(),
      title: model.title,
      thumb: thumb,
      artist: model.artist,
      dateAdded: model.dateAdded,
      duration: model.duration == null ? null : formatTime(model.duration!),
      uri: model.uri!);
}
