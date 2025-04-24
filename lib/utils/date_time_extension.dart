part of 'utils.dart';

extension DateTimeExtension on DateTime {
  String format({String pattern = 'MMMM yyyy'}) {
    return DateFormat(pattern).format(this);
  }
}
