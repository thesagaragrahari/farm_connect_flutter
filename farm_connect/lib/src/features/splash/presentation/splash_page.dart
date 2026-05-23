import 'dart:async';

import 'package:farm_connect/src/features/splash/presentation/splash_animation_spec.dart';
import 'package:farm_connect/src/features/splash/presentation/widgets/farm_connect_splash.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  final String nextLocation;

  const SplashPage({
    super.key,
    this.nextLocation = '/preview',
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _handoffTimer;

  @override
  void initState() {
    super.initState();
    _handoffTimer = Timer(SplashAnimationSpec.totalDuration, () {
      if (!mounted) return;
      context.go(widget.nextLocation);
    });
  }

  @override
  void dispose() {
    _handoffTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const FarmConnectSplash();
  }
}
