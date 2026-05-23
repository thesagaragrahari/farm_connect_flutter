import 'package:flutter/material.dart';

class SplashAnimationSpec {
  const SplashAnimationSpec._();

  static const totalDuration = Duration(milliseconds: 2600);
  static const backgroundFade = Duration(milliseconds: 900);
  static const logoSettle = Duration(milliseconds: 1100);
  static const textRise = Duration(milliseconds: 850);
  static const particleDrift = Duration(milliseconds: 2400);

  static const backgroundCurve = Curves.easeOutCubic;
  static const logoCurve = Curves.easeOutCubic;
  static const textCurve = Curves.easeOutCubic;
}
