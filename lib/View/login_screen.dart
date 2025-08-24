import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../controller/auth_controller.dart';
import '../models/hero_slide.dart';
import '../widgets/blue_hero.dart';
import '../widgets/phone_panel.dart' ;

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final c = Get.put(AuthController());

  final slides = const [
    HeroSlide(
      asset: 'assets/images/img.png',
      title: 'Flexible Loan Options',
      subtitle: 'Loan types to cater to different financial needs',
    ),
    HeroSlide(
      asset: 'assets/images/img_1.png',
      title: 'Instant Loan Approval',
      subtitle: 'Users will receive approval within minutes',
    ),
    HeroSlide(
      asset: 'assets/images/img_2.png',
      title: '24x7 Customer Care',
      subtitle: 'Dedicated customer support team',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF0C4DA2),),
      backgroundColor: const Color(0xFF0C4DA2),
      resizeToAvoidBottomInset: true,
      body: SlidingUpPanel(
        minHeight: size.height * 0.5,
        maxHeight: size.height * 0.7,
        isDraggable: false,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        body: Column(
          children: [
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png', height: size.height * 0.06),
                const SizedBox(width: 6),
                const Text('Credit',
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                const Text('Sea',
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w200)),
              ],
            ),
            const SizedBox(height: 10),
            Obx(() => BlueHero(
              slides: slides,
              controller: c.heroPage,
              currentIndex: c.stepIndex,
              height: size.height * 0.28,
              onPageChanged: (i) {
                c.currentStep.value = AuthStep.values[i];
              },
            )),
            const Spacer(),
          ],
        ),
        panel: Obx(() {
          switch (c.currentStep.value) {
            case AuthStep.phone:
              return PhonePanel(onNext: c.onRequestOtp);
            case AuthStep.otp:
              return OtpPanel(onVerified: c.onOtpVerified);
            case AuthStep.password:
              return PasswordPanel(onDone: c.onPasswordCreated);
            case AuthStep.signin:
              return const SigninPanel();
          }
        }),
      ),
    );
  }
}
