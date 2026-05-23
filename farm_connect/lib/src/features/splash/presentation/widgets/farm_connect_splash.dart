import 'package:farm_connect/src/core/theme/app_theme.dart';
import 'package:farm_connect/src/features/splash/presentation/splash_animation_spec.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FarmConnectSplash extends StatelessWidget {
  const FarmConnectSplash({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.width < 420;
    final logoSize = compact ? 108.0 : 128.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _CinematicBackground().animate().fadeIn(
                duration: SplashAnimationSpec.backgroundFade,
                curve: SplashAnimationSpec.backgroundCurve,
              ),
          const _AmbientParticles(),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LogoMark(size: logoSize)
                        .animate()
                        .scale(
                          begin: const Offset(0.92, 0.92),
                          end: const Offset(1, 1),
                          duration: SplashAnimationSpec.logoSettle,
                          curve: SplashAnimationSpec.logoCurve,
                        )
                        .fadeIn(
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeOut,
                        ),
                    const SizedBox(height: 24),
                    const _BrandLockup()
                        .animate(delay: const Duration(milliseconds: 520))
                        .fadeIn(
                          duration: SplashAnimationSpec.textRise,
                          curve: SplashAnimationSpec.textCurve,
                        )
                        .slideY(
                          begin: 0.16,
                          end: 0,
                          duration: SplashAnimationSpec.textRise,
                          curve: SplashAnimationSpec.textCurve,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CinematicBackground extends StatelessWidget {
  const _CinematicBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF020604),
            Color(0xFF07130B),
            Color(0xFF102116),
            Color(0xFF1B150B),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: const [
          _LightWash(),
          _FarmlandAtmosphere(),
        ],
      ),
    );
  }
}

class _LightWash extends StatelessWidget {
  const _LightWash();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.12, -0.22),
          radius: 0.86,
          colors: [
            AppTheme.metallicGold.withValues(alpha: 0.12),
            AppTheme.forestGreen.withValues(alpha: 0.10),
            Colors.transparent,
          ],
          stops: const [0.0, 0.36, 1.0],
        ),
      ),
    );
  }
}

class _FarmlandAtmosphere extends StatelessWidget {
  const _FarmlandAtmosphere();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _FarmlandPainter());
  }
}

class _FarmlandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final horizon = size.height * 0.64;
    final fieldPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.forestGreen.withValues(alpha: 0.00),
          AppTheme.forestGreen.withValues(alpha: 0.14),
          const Color(0xFF0B0905).withValues(alpha: 0.40),
        ],
      ).createShader(Offset.zero & size);

    final fieldPath = Path()
      ..moveTo(0, horizon)
      ..quadraticBezierTo(size.width * 0.32, horizon - 26, size.width, horizon)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fieldPath, fieldPaint);

    final linePaint = Paint()
      ..color = AppTheme.metallicGold.withValues(alpha: 0.08)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 7; i++) {
      final y = horizon + 32 + (i * size.height * 0.045);
      final path = Path()
        ..moveTo(size.width * -0.08, y)
        ..quadraticBezierTo(
          size.width * 0.46,
          y + 18 + (i * 3),
          size.width * 1.08,
          y - 4,
        );
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AmbientParticles extends StatelessWidget {
  const _AmbientParticles();

  static const _particles = <_ParticleSpec>[
    _ParticleSpec(0.14, 0.24, 1.8, 0),
    _ParticleSpec(0.28, 0.68, 1.4, 180),
    _ParticleSpec(0.42, 0.18, 1.2, 320),
    _ParticleSpec(0.58, 0.76, 1.6, 90),
    _ParticleSpec(0.72, 0.30, 1.3, 260),
    _ParticleSpec(0.84, 0.58, 1.7, 140),
    _ParticleSpec(0.18, 0.82, 1.1, 420),
    _ParticleSpec(0.66, 0.48, 1.0, 560),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return Stack(
          children: [
            for (final particle in _particles)
              Positioned(
                left: size.width * particle.dx,
                top: size.height * particle.dy,
                child: _Particle(size: particle.size)
                    .animate(delay: Duration(milliseconds: particle.delayMs))
                    .fadeIn(
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOut,
                    )
                    .move(
                      begin: Offset.zero,
                      end: const Offset(10, -16),
                      duration: SplashAnimationSpec.particleDrift,
                      curve: Curves.easeInOut,
                    ),
              ),
          ],
        );
      },
    );
  }
}

class _Particle extends StatelessWidget {
  final double size;

  const _Particle({required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.metallicGold.withValues(alpha: 0.26),
          boxShadow: [
            BoxShadow(
              color: AppTheme.metallicGold.withValues(alpha: 0.08),
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  final double size;

  const _LogoMark({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF6D0),
            Color(0xFFD4A84F),
            Color(0xFF8F6428),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.metallicGold.withValues(alpha: 0.20),
            blurRadius: 28,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppTheme.forestGreen.withValues(alpha: 0.24),
            blurRadius: 42,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          AppTheme.darkAppIconUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/farm_connect_app_icon.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    ).animate(delay: const Duration(milliseconds: 240)).boxShadow(
          begin: BoxShadow(
            color: AppTheme.metallicGold.withValues(alpha: 0.00),
            blurRadius: 0,
          ),
          end: BoxShadow(
            color: AppTheme.metallicGold.withValues(alpha: 0.16),
            blurRadius: 24,
            spreadRadius: 2,
          ),
          duration: const Duration(milliseconds: 1100),
          curve: Curves.easeOutCubic,
        );
  }
}

class _BrandLockup extends StatelessWidget {
  const _BrandLockup();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'FarmConnect',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.darkText,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Premium agritech for trusted field work',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.darkMutedText.withValues(alpha: 0.78),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ParticleSpec {
  final double dx;
  final double dy;
  final double size;
  final int delayMs;

  const _ParticleSpec(this.dx, this.dy, this.size, this.delayMs);
}
