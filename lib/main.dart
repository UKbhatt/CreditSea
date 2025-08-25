import 'package:creditsea/View/detail_screen.dart';
import 'package:flutter/material.dart';
import 'View/splash_screen.dart';
import 'View/login_screen.dart';
import 'package:get/get.dart';
import 'View/loan_calculator.dart';
import 'controller/step_controller.dart';
import 'View/offer.dart';
import 'View/application_screen.dart';
import 'data/api_client.dart';
import 'controller/auth_controller.dart';
import 'controller/hero_slider_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => HeroSliderController().init(), permanent: true);
  Get.put(StepController());
  Get.put(AuthController());
  ApiClient().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      initialRoute: '/' ,
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/details', page: () => DetailsScreen()),
        GetPage(name: '/loanCalculator', page: () => LoanCalculatorPage()),
        GetPage(name: '/offer', page: () => OfferScreen()),
        GetPage(name: '/application', page: () => ApplicationStatusScreen())
      ],
      title: 'CreditSea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
