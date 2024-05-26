extension DurationExts on Duration {
  String get formatAsSongDuration {
    final sec = inSeconds % 60;
    final min = inSeconds / 60;
    return "${min.floor().toString().padLeft(2, "0")}:${sec.toString().padLeft(2, "0")}";
  }
}
