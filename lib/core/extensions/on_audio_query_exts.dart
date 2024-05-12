import 'dart:io';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';

extension OnAudioQueryExts on OnAudioQuery {
  static final thumbList = <int, Uri>{};

  Future<Uri?> getThumb(SongModel song) async {
    if (!thumbList.containsKey(song.id)) {
      await loadThumb(song);
    }
    return thumbList[song.id];
  }

  loadThumb(SongModel song) async {
    final path = await generatePath(song);
    var file = File(path);
    if (file.existsSync()) {
      thumbList[song.id] = file.uri;
      return;
    }
    final bytes = await queryArtwork(song.id, ArtworkType.AUDIO);
    if (bytes == null) return null;

    file = await File(path).writeAsBytes(bytes);
    thumbList[song.id] = file.uri;
  }

  Future<String> generatePath(SongModel song) async {
    final sub = '/${song.id}-${song.dateModified ?? 0}.png';
    final dir = await getApplicationSupportDirectory();
    return dir.path + sub;
  }
}
