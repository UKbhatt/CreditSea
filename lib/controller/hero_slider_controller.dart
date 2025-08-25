import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HeroSliderController extends GetxService {
  final page = PageController();
  final index = 0.obs;

  void onPageChanged(int i) => index.value = i;

  Future<HeroSliderController> init() async => this;

  @override
  void onClose() {
    page.dispose();
    super.onClose();
  }
}
