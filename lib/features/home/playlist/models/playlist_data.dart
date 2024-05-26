class PlaylistData {
  final List<PlaylistItem> playlistItems;

  PlaylistData({required this.playlistItems});
}

class PlaylistItem {
  final int playlistId;
  final String playlistName;
  final int count;
  final String? firstThumbUri;

  PlaylistItem(
      {required this.playlistId,
      required this.playlistName,
      required this.count,
      required this.firstThumbUri});
  factory PlaylistItem.fromMap(Map<String, dynamic> map) {
    return PlaylistItem(
        playlistId: map['id'],
        playlistName: map['name'],
        count: map['count'],
        firstThumbUri: map['firstThumbUri']);
  }
}
