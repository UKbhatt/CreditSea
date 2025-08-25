import 'package:flutter/material.dart';
import 'otp_code_input.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../constants/hero_slides.dart';

class CheckController extends GetxController {
  var check = false.obs;
  var mobile = ''.obs;

  bool get canProceed => check.value && mobile.value.length == 10;
}

class PhonePanel extends StatelessWidget {
  PhonePanel({required this.onNext});
  final VoidCallback onNext;
  TextEditingController mobileController = TextEditingController() ;

  @override
  Widget build(BuildContext context) {
    final CheckController c = Get.put(CheckController());
    final height = MediaQuery.of(context).size.height ;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Welcome to Credit Sea!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Mobile Number'),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.phone,
            controller: mobileController,
            maxLength: 10,
            onChanged: (v) => c.mobile.value = v.replaceAll(RegExp(r'\D'), ''),
            decoration: const InputDecoration(
              hintText: 'Please enter your mobile no.',
              border: OutlineInputBorder(),
              counterText: '',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Obx(() => Checkbox(
                value: c.check.value,
                onChanged: (value) {
                  c.check.value = value ?? false ;
                  if(!c.check.value) {
                    Get.snackbar("Accept the Terms and Conditions",
                      "Without accepting terms you can't register"
                      ,snackPosition: SnackPosition.TOP, );

                  }
                },
              )),
              const Expanded(
                child: Text(
                  'By continuing, you agree to our privacy policies and Terms & Conditions.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {

                String s = mobileController.text ;
                if(s.length != 10) {
                  Get.snackbar("Invalid Mobile number",
                    "Please enter valid mobile number"
                    ,snackPosition: SnackPosition.TOP, );
                  return ;
                }
                Get.snackbar(
                  'OTP Sent',
                  'Demo OTP: 1234',
                  snackPosition: SnackPosition.TOP,
                );
                onNext();
              },
              child: const Text('Request OTP' , style: TextStyle(color: Colors.white),),
            ),
          ),
          SizedBox(height: (height)*0.08),
           Center(child: TextButton(
             onPressed: (){
               Get.find<AuthController>().goTo(AuthStep.signin);
             },
             child: Text( 'Existing User? Sign in',
              style: TextStyle(color: Colors.blue.shade800 , fontWeight: FontWeight.bold,),
            ),)
           )
        ],
      ),
    );
  }
}
class OtpPanel extends StatelessWidget {
  const OtpPanel({
    required this.onVerified,
    this.phoneLabel = '+91 8800642354', // show your masked/real number
    this.timerText = '00:28',
  });

  final VoidCallback onVerified;
  final String phoneLabel;
  final String timerText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Get.find<AuthController>().goTo(AuthStep.phone),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Enter OTP',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Opacity(
                opacity: 0,
                child: IconButton(onPressed: null, icon: Icon(Icons.arrow_back)),
              ),
            ],
          ),
          const SizedBox(height: 8),

          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Colors.black87),
              children: [
                const TextSpan(text: 'Verify OTP, Sent on '),
                TextSpan(
                  text: phoneLabel,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          OtpCodeInput(
            length: 4,
            onChanged: (_) {},
            onCompleted: (code) {
              if (code == '1234') {
                onVerified();
              } else {
                Get.snackbar('Error', 'Invalid OTP (demo: 1234)');
              }
            },
          ),
          const SizedBox(height: 12),

          Text(
            timerText,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: onVerified,
              child: const Text('Verify'),
            ),
          ),
        ],
      ),
    );
  }
}


class PasswordPanel extends StatelessWidget {
  const PasswordPanel({required this.onDone});
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Get.find<AuthController>().goTo(AuthStep.otp),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
          const Text(
            'Create a password',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter password',
            ),
          ),
          const SizedBox(height: 10),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Re enter password',
            ),
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Your password must include at least 8 characters, inclusive of at least 1 special character',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDone,
              child: const Text('Proceed'),
            ),
          ),

        ],
      ),
    );
  }
}

class SigninPanel extends StatefulWidget {
  const SigninPanel({super.key});

  @override
  State<SigninPanel> createState() => _SigninPanelState();
}

class _SigninPanelState extends State<SigninPanel> {
  bool _obscurePassword = true;
  TextEditingController numberController = TextEditingController() ;
  TextEditingController passwordController = TextEditingController () ;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Get.find<AuthController>();
      final last = defaultHeroSlides.length - 1;

      auth.currentStep.value = AuthStep.signin;

      if (auth.heroPage.hasClients) {
        auth.heroPage.animateToPage(
          last,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      } else {
        try { auth.heroPage.jumpToPage(last); } catch (_) {}
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: Text(
              'Please enter your credentials',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),

          const Text(
            "Mobile Number",
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 6),
          TextField(
            controller: numberController,
            decoration: const InputDecoration(
              prefixText: '+91 ',
              border: OutlineInputBorder(),
              hintText: 'Please enter your mobile no.',
            ),
          ),

          const SizedBox(height: 14),
          const Text(
            "Password",
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 6),
          TextField(
            controller: passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: 'Enter password',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                String s = numberController.text ;
                String p = passwordController.text ;
                if(s.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(p)) {
                  Get.snackbar(
                    "Error",
                    "Enter a valid 10-digit mobile number",
                    snackPosition: SnackPosition.TOP,
                  );
                  return;
                }
                Get.toNamed('/details');
              },
              child: const Text('Sign In'),
            ),
          ),
          Center(child: TextButton(
            onPressed: (){
              Get.find<AuthController>().goTo(AuthStep.phone);
            },
            child: Text( 'New to CreditSea? Create an account',
              style: TextStyle(color: Colors.blue.shade800 , fontWeight: FontWeight.bold,),
            ),)
          )
        ],
      ),
    );
  }
}
