import 'package:flutter/widgets.dart';

class R {
  static bool isPhone(BuildContext c) => MediaQuery.sizeOf(c).width < 600;
  static bool isTablet(BuildContext c) => MediaQuery.sizeOf(c).width >= 600 && MediaQuery.sizeOf(c).width < 1024;
  static bool isDesktop(BuildContext c) => MediaQuery.sizeOf(c).width >= 1024;
}
