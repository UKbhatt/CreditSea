import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF0C4DA2),
      body: SlidingUpPanel(
        minHeight: MediaQuery.of(context).size.height * 0.35,
        maxHeight: MediaQuery.of(context).size.height * 0.55,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        panel: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Welcome to Credit Sea!",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Mobile Number"),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "+91 ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  hintText: "Please enter your mobile no.",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Checkbox + Terms
              Row(
                children: [
                  Checkbox(value: true, onChanged: (val) {}),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "By continuing, you agree to our ",
                        children: [
                          TextSpan(
                            text: "privacy policies",
                            style: TextStyle(color: Colors.blue.shade700),
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "Terms & Conditions.",
                            style: TextStyle(color: Colors.blue.shade700),
                          ),
                        ],
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              // OTP Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    // Navigate to OTP Screen
                    Get.toNamed('/otp');
                  },
                  child: const Text(
                    "Request OTP",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: GestureDetector(
                  onTap: () => Get.toNamed('/login'),
                  child: const Text(
                    "Existing User? Sign in",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            // Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png", height: height * 0.08),
                const Text(
                  "Credit",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Sea",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Image.asset(
              "assets/images/img.png",
              height: height * 0.2,
              width: width * 0.4,
            ),
            const SizedBox(height: 10),
            const Text(
              "Flexible Loan Options",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              "Loan types to cater to different financial needs",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
