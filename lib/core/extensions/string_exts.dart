extension StringExts on String {
  Uri get asUri => Uri.parse(this);
}
