import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/step_controller.dart';
import '../widgets/step_header.dart';

class ApplicationStatusScreen extends StatefulWidget {
  const ApplicationStatusScreen({
    super.key,
    this.applicationNo = '#CS12323',
  });

  final String applicationNo;

  @override
  State<ApplicationStatusScreen> createState() => _ApplicationStatusScreenState();
}

class _ApplicationStatusScreenState extends State<ApplicationStatusScreen> {
  final stepCtrl = Get.find<StepController>();
  static const _blue = Color(0xFF0A66FF);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stepCtrl.setStep(DetailsStep.approval);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _blue,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Get.offNamed('/extra') ;
              },
              child: const Text('Continue'),
            ),
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
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2))],
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                            onPressed: () => Get.back(),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Application Status',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Loan application no. ${widget.applicationNo}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12.5),
                      ),
                      const SizedBox(height: 14),

                      _StageTile(
                        label: 'Application Submitted',
                        state: StageState.done,
                        icon: Icons.description_rounded,
                      ),
                      _StageTile(
                        label: 'Application under Review',
                        state: StageState.active,
                        icon: Icons.event_note_rounded,
                      ),
                      _StageTile(
                        label: 'E-KYC',
                        state: StageState.locked,
                        icon: Icons.event_note_rounded,
                      ),
                      _StageTile(
                        label: 'E-Nach',
                        state: StageState.locked,
                        icon: Icons.event_note_rounded,
                      ),
                      _StageTile(
                        label: 'E-Sign',
                        state: StageState.locked,
                        icon: Icons.event_note_rounded,
                      ),
                      _StageTile(
                        label: 'Disbursement',
                        state: StageState.locked,
                        icon: Icons.event_note_rounded,
                      ),

                      const SizedBox(height: 5),

                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF4FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.rate_review_rounded, size: 32, color: _blue),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Application Under Review',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "We're carefully reviewing your application to ensure "
                                "everything is in order. Thank you for your patience.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


enum StageState { done, active, locked }

class _StageTile extends StatelessWidget {
  const _StageTile({
    required this.label,
    required this.state,
    required this.icon,
  });

  final String label;
  final StageState state;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0A66FF);
    const green = Color(0xFF2ECC71);

    Color border;
    Color fill;
    Color textColor;
    Color iconColor;

    switch (state) {
      case StageState.done:
        border = green;
        fill = const Color(0xFFEAF7F0);
        textColor = Colors.black87;
        iconColor = green;
        break;
      case StageState.active:
        border = blue;
        fill = const Color(0xFFEAF1FF);
        textColor = Colors.black87;
        iconColor = blue;
        break;
      case StageState.locked:
        border = const Color(0xFFE0E5EC);
        fill = const Color(0xFFF6F8FB);
        textColor = Colors.black45;
        iconColor = Colors.grey.shade500;
        break;
    }

    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border, width: 1.6),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: border),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
