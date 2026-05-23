import 'package:flutter/material.dart';

@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final bool lightMode;
  final Color pageBackground;
  final List<Color> outerGradient;
  final List<Color> shellGradient;
  final Color tabBackground;
  final Color bottomBar;
  final Color card;
  final Color divider;
  final Color primaryText;
  final Color secondaryText;
  final Color iconActive;
  final Color iconInactive;

  const AppPalette({
    required this.lightMode,
    required this.pageBackground,
    required this.outerGradient,
    required this.shellGradient,
    required this.tabBackground,
    required this.bottomBar,
    required this.card,
    required this.divider,
    required this.primaryText,
    required this.secondaryText,
    required this.iconActive,
    required this.iconInactive,
  });

  static const dark = AppPalette(
    lightMode: false,
    pageBackground: Color(0xFF07130B),
    outerGradient: [
      Color(0xFF07130B),
      Color(0xFF102817),
      Color(0xFF2A1F11),
    ],
    shellGradient: [
      Color(0xFF102116),
      Color(0xFF07180D),
      Color(0xFF241A0E),
    ],
    tabBackground: Color(0xFF142319),
    bottomBar: Color(0xFF0B1A10),
    card: Color(0xFF13251A),
    divider: Color(0xFF3B4A2F),
    primaryText: Color(0xFFEAF8E5),
    secondaryText: Color(0xFFB7D6A9),
    iconActive: Colors.white,
    iconInactive: Color(0xFF92A08B),
  );

  static const light = AppPalette(
    lightMode: true,
    pageBackground: Color(0xFFF8F1E3),
    outerGradient: [
      Color(0xFFFFFAEF),
      Color(0xFFEAF3DF),
      Color(0xFFE8D7AE),
    ],
    shellGradient: [
      Color(0xFFFFFAEE),
      Color(0xFFEDF5E4),
      Color(0xFFE9D5A4),
    ],
    tabBackground: Color(0xFFEAF2DE),
    bottomBar: Color(0xFFF8EEDA),
    card: Color(0xFFFFFBF1),
    divider: Color(0xFFD7BF82),
    primaryText: Color(0xFF213A22),
    secondaryText: Color(0xFF647050),
    iconActive: Color(0xFF245C27),
    iconInactive: Color(0xFF6E7D5A),
  );

  static AppPalette fromBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }

  @override
  AppPalette copyWith({
    bool? lightMode,
    Color? pageBackground,
    List<Color>? outerGradient,
    List<Color>? shellGradient,
    Color? tabBackground,
    Color? bottomBar,
    Color? card,
    Color? divider,
    Color? primaryText,
    Color? secondaryText,
    Color? iconActive,
    Color? iconInactive,
  }) {
    return AppPalette(
      lightMode: lightMode ?? this.lightMode,
      pageBackground: pageBackground ?? this.pageBackground,
      outerGradient: outerGradient ?? this.outerGradient,
      shellGradient: shellGradient ?? this.shellGradient,
      tabBackground: tabBackground ?? this.tabBackground,
      bottomBar: bottomBar ?? this.bottomBar,
      card: card ?? this.card,
      divider: divider ?? this.divider,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      iconActive: iconActive ?? this.iconActive,
      iconInactive: iconInactive ?? this.iconInactive,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      lightMode: t < 0.5 ? lightMode : other.lightMode,
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      outerGradient: _lerpColors(outerGradient, other.outerGradient, t),
      shellGradient: _lerpColors(shellGradient, other.shellGradient, t),
      tabBackground: Color.lerp(tabBackground, other.tabBackground, t)!,
      bottomBar: Color.lerp(bottomBar, other.bottomBar, t)!,
      card: Color.lerp(card, other.card, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      iconActive: Color.lerp(iconActive, other.iconActive, t)!,
      iconInactive: Color.lerp(iconInactive, other.iconInactive, t)!,
    );
  }

  static List<Color> _lerpColors(List<Color> a, List<Color> b, double t) {
    final length = a.length < b.length ? a.length : b.length;
    return List<Color>.generate(
      length,
      (index) => Color.lerp(a[index], b[index], t)!,
      growable: false,
    );
  }
}
