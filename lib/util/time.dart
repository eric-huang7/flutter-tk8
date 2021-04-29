String formatDuration(Duration duration) {
  if (duration == null) return '--:--';
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  final twoDigitsHours =
      duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : '';
  return "$twoDigitsHours$twoDigitMinutes:$twoDigitSeconds";
}

String formatDurationOneSecond(Duration duration) {
  if (duration == null) return '--:--';
  String twoDigits(int n) => n.toString().padLeft(3, "0");
  final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  final twoDigitsHours =
      duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : '';
  return "$twoDigitsHours$twoDigitMinutes:$twoDigitSeconds";
}
