import 'package:flutter/material.dart';
import 'otp_code_input.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
class PhonePanel extends StatelessWidget {
  const PhonePanel({required this.onNext});
  final VoidCallback onNext;
  @override
  Widget build(BuildContext context) {
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
          const TextField(
            decoration: InputDecoration(
              hintText: 'Please enter your mobile no.',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(value: true, onChanged: (_) {}),
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
              onPressed: () {
                Get.snackbar(
                  'OTP Sent',
                  'Demo OTP: 1234',
                  snackPosition: SnackPosition.TOP,
                );
                onNext();
              },
              child: const Text('Request OTP'),
            ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              'Existing User? Sign in',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

class OtpPanel extends StatelessWidget {
  const OtpPanel({required this.onVerified});
  final VoidCallback onVerified;

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
              onPressed: () => Get.find<AuthController>().goTo(AuthStep.phone),
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
          const Text(
            'Enter OTP',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Verify OTP, Sent on +91 ••••1234',
            style: TextStyle(fontSize: 13),
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
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

class SigninPanel extends StatelessWidget {
  const SigninPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Please enter your credentials',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(
              prefixText: '+91 ',
              border: OutlineInputBorder(),
              hintText: 'Please enter your mobile no.',
            ),
          ),
          const SizedBox(height: 10),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter password',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed('/details');
              },
              child: const Text('Proceed'),
            ),
          ),
        ],
      ),
    );
  }
}
