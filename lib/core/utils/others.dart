class MyUtils {
  Future<void> openAppSetting() async {}
}

const _totalMilliSecondsInHour = 3600 * 1000;
const _totalMilliSecondsInMin = 60 * 1000;
String formatTime(int timestamp) {
  final hours = timestamp / _totalMilliSecondsInHour;
  final min = (timestamp % _totalMilliSecondsInHour ~/ _totalMilliSecondsInMin);
  final sec = (timestamp % _totalMilliSecondsInMin) ~/ 1000;

  return "${hours >= 1 ? '${hours.toString().padLeft(2, '0')}:' : ''}${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
}
