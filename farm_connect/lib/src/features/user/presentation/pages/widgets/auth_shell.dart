import 'dart:math' as math;

import 'package:flutter/material.dart';

const Color kAuthBgTop = Color(0xFF071224);
const Color kAuthBgBottom = Color(0xFF030913);
const Color kAuthCard = Color(0xFF0D1A2D);
const Color kAuthCardBorder = Color(0xFF1D3554);
const Color kAuthAccent = Color(0xFF33D17A);
const Color kAuthTextPrimary = Color(0xFFEAF2FF);
const Color kAuthTextSecondary = Color(0xFF9FB3CC);

class AuthShell extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final List<Widget>? footerActions;

  const AuthShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footerActions,
  });

  @override
  State<AuthShell> createState() => _AuthShellState();
}

class _AuthShellState extends State<AuthShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, _) {
          final progress = _backgroundController.value;
          final driftX = math.sin(progress * math.pi * 2) * 16;
          final driftY = math.cos(progress * math.pi * 2) * 20;

          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [kAuthBgTop, kAuthBgBottom],
                  ),
                ),
              ),
              Positioned(
                top: -120 + driftY,
                right: -90 + driftX,
                child: _GlowBubble(
                  size: 320,
                  color: kAuthAccent.withValues(alpha: 0.15),
                ),
              ),
              Positioned(
                bottom: -150 - driftY,
                left: -100 - driftX,
                child: _GlowBubble(
                  size: 360,
                  color: const Color(0xFF2BCB7F).withValues(alpha: 0.08),
                ),
              ),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 28,
                    ),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, (1 - value) * 26),
                            child: child,
                          ),
                        );
                      },
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 460),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: kAuthCard,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(color: kAuthCardBorder),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.35),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _AuthBrand(),
                              const SizedBox(height: 18),
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  color: kAuthTextPrimary,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.subtitle,
                                style: const TextStyle(
                                  color: kAuthTextSecondary,
                                  height: 1.45,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 26),
                              widget.child,
                              if (widget.footerActions != null &&
                                  widget.footerActions!.isNotEmpty) ...[
                                const SizedBox(height: 14),
                                ...widget.footerActions!,
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GlowBubble extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowBubble({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
            stops: const [0.1, 0.95],
          ),
        ),
      ),
    );
  }
}

class _AuthBrand extends StatelessWidget {
  const _AuthBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: 'farm-connect-brand-logo',
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kAuthAccent, width: 1.8),
              boxShadow: [
                BoxShadow(
                  color: kAuthAccent.withValues(alpha: 0.22),
                  blurRadius: 18,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/farm_connect_app_icon.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'KrishiSetu',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kAuthTextPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}
