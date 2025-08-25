import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/hero_slider_controller.dart';
import '../models/hero_slide.dart';
import 'blue_hero.dart';

class GlobalHeroSlider extends StatelessWidget {
  const GlobalHeroSlider({
    super.key,
    required this.slides,
    required this.height,
    this.onPageChanged,
  });

  final List<HeroSlide> slides;
  final double height;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    final hero = Get.find<HeroSliderController>();
    return Obx(() => BlueHero(
      slides: slides,
      controller: hero.page,
      currentIndex: hero.index.value,
      height: height,
      onPageChanged: (i) {
        hero.onPageChanged(i);
        onPageChanged?.call(i);
      },
    ));
  }
}
