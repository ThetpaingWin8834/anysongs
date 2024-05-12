extension ListExts<T> on List<T> {
  int get middleIndex => isEmpty
      ? 0
      : length < 2
          ? 1
          : length ~/ 2;
  T get middle {
    if (length < 2) {
      return first;
    } else {
      return this[length ~/ 2];
    }
  }
}
