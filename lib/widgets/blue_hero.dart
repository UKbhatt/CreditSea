import 'package:flutter/material.dart';
import '../models/hero_slide.dart';
import 'step_dots.dart';

class BlueHero extends StatelessWidget {
  const BlueHero({
    super.key,
    required this.slides,
    required this.controller,
    required this.currentIndex,
    this.height = 260,
    this.onPageChanged,
  });

  final List<HeroSlide> slides;
  final PageController controller;
  final int currentIndex;
  final double height;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0C4DA2),
      height: height,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              onPageChanged: onPageChanged,
              itemCount: slides.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (_, i) {
                final s = slides[i];
                return Column(
                  children: [
                    SizedBox(
                      height: 120,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: ScaleTransition(
                            scale: Tween(begin: .98, end: 1.0).animate(anim),
                            child: child,
                          ),
                        ),
                        child: Image.asset(s.asset, key: ValueKey(s.asset)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(s.title,
                          key: ValueKey(s.title),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 6),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(s.subtitle,
                          key: ValueKey(s.subtitle),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          StepDots(count: slides.length, index: currentIndex),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
