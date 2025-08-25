import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AuthStep { phone, otp, password, signin }

class AuthController extends GetxController {
  final currentStep = AuthStep.phone.obs;

  final PageController heroPage = PageController();

  int get stepIndex => currentStep.value.index.clamp(0, 2);

  void goTo(AuthStep step) {
    currentStep.value = step;
    if (step.index <= 2) {
      heroPage.animateToPage(
        step.index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onRequestOtp() => goTo(AuthStep.otp);
  void onOtpVerified() => goTo(AuthStep.password);
  void onPasswordCreated() => goTo(AuthStep.signin);

  @override
  void onClose() {
    heroPage.dispose();
    super.onClose();
  }
}
