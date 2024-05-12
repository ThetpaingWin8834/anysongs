extension TypeExts<T> on T {
  T also(void Function(T) func) {
    func(this);
    return this;
  }
}
