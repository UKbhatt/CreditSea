import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/step_controller.dart';
import '../widgets/step_header.dart';

class OfferScreen extends StatelessWidget {
  OfferScreen({
    super.key,
    this.amount = 10000,
    this.payable = 10600,
    this.tenureDays = 90,
    this.creditMinutes = 30,
  });

  final int amount;
  final int payable;
  final int tenureDays;
  final int creditMinutes;

  final _num = NumberFormat.decimalPattern('en_IN');
  final StepController stepCtrl = Get.find<StepController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0A66FF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    stepCtrl.setStep(DetailsStep.approval) ;
                    Get.offAllNamed('/application');
                  },
                  child: const Text('Accept Offer'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(color: Color(0xFF0A66FF)),
                  ),
                  onPressed: () {
                    Get.snackbar('Extend Offer', 'We’ll explore better terms for you.');
                  },
                  child: const Text('Extend Offer'),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() => StepHeader(
                index: stepCtrl.stepIndex,
                labels: const ['Register', 'Offer', 'Approval'],
                onTap: (i) => stepCtrl.setStep(DetailsStep.values[i]),
              )),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Our Offerings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    Image.asset(
                      'assets/images/coin.gif',
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),

                    Padding(
                        padding: EdgeInsetsGeometry.only(left: 5 ,right: 5),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.45,
                            color: Colors.black87,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Congratulations! ',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: 'We can offer you '),
                            TextSpan(
                              text: 'Rs. ${_num.format(amount)}',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const TextSpan(text: ' Amount Within '),
                            TextSpan(
                              text: '${_num.format(creditMinutes)} minutes ',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const TextSpan(text: 'for '),
                            TextSpan(
                              text: '${_num.format(tenureDays)} days',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const TextSpan(text: ', with a payable amount of '),
                            TextSpan(
                              text: 'Rs. ${_num.format(payable)}',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const TextSpan(text: '. Just with few more steps.'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Proceed further to',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
