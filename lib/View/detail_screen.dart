import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../controller/step_controller.dart';
import '../widgets/step_header.dart';
import '../data/auth_service.dart';
import 'package:dio/dio.dart';

enum RegisterSubStep { personal, emailOtp, pan }

class DetailsController extends GetxController {
  final isLoading = true.obs;

  final stepCtrl = Get.find<StepController>();
  int get stepIndex => stepCtrl.stepIndex;

  final subStep = RegisterSubStep.personal.obs;

  final firstName = TextEditingController();
  final lastName  = TextEditingController();
  final gender = RxnString();
  final maritalStatus = RxnString();
  final dob = Rxn<DateTime>();

  final email = TextEditingController();
  var emailOtp = ''.obs;

  final pan = TextEditingController();

  final otpSecondsLeft = 28.obs;
  Timer? _otpTimer;

  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 2), () => isLoading.value = false);
  }


  final _auth = AuthService();

  Future<void> submitRegistration() async {
    try {
      final payload = {
        'firstName': firstName.text.trim(),
        'lastName': lastName.text.trim(),
        'gender': gender.value,
        'maritalStatus': maritalStatus.value,
        'dob': dob.value!.toIso8601String(),   // ISO for backend
        'email': email.text.trim().toLowerCase(),
        'pan': pan.text.trim().toUpperCase(),
        'password': 'TempPass#2025',
      };

      final user = await _auth.register(payload);
      Get.toNamed('/loanCalculator');
    } on DioException catch (e) {
      final msg = e.response?.data?['error'] ?? e.message;
      Get.snackbar('Registration failed', msg.toString());
    } catch (e) {
      Get.snackbar('Registration failed', e.toString());
    }
  }

  Future<void> pickDob(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 21, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) dob.value = picked;
  }

  String get dobLabel {
    if (dob.value == null) return 'DD - MM - YYYY';
    final d = dob.value!;
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$dd - $mm - $yy';
  }

  bool _validEmail(String v) =>
      RegExp(r"^[\w\.\-]+@[\w\-]+\.[A-Za-z]{2,}$").hasMatch(v.trim());
  bool _validPan(String v) =>
      RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]$").hasMatch(v.trim());

  Future<void> onContinue() async {
    final s = stepCtrl;

    if (s.step.value == DetailsStep.register) {
      if (subStep.value == RegisterSubStep.personal) {
        if (firstName.text.trim().isEmpty ||
            lastName.text.trim().isEmpty ||
            gender.value == null ||
            maritalStatus.value == null ||
            dob.value == null) {
          Get.snackbar('Missing info', 'Please fill all required fields');
          return;
        }
        subStep.value = RegisterSubStep.emailOtp;
        startOtpTimer();
        return;
      }

      if (subStep.value == RegisterSubStep.emailOtp) {
        if (!_validEmail(email.text)) {
          Get.snackbar('Invalid email', 'Please enter a valid email ID');
          return;
        }
        if (emailOtp.value.length != 6) {
          Get.snackbar('OTP required', 'Please enter the 6-digit OTP');
          return;
        }
        subStep.value = RegisterSubStep.pan;
        return;
      }

      if (subStep.value == RegisterSubStep.pan) {
        if (!_validPan(pan.text.toUpperCase())) {
          Get.snackbar('Invalid PAN', 'Format: ABCDE1234F');
          return;
        }
        await submitRegistration();
        Get.offAllNamed('/loanCalculator');
        return;
      }
    }

    if (s.step.value == DetailsStep.offer) {
      s.setStep(DetailsStep.approval);
    } else if (s.step.value == DetailsStep.approval) {
      Get.offAllNamed('/home');
    }
  }


  void startOtpTimer() {
    _otpTimer?.cancel();
    otpSecondsLeft.value = 28;
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (otpSecondsLeft.value <= 0) {
        t.cancel();
      } else {
        otpSecondsLeft.value--;
      }
    });
  }

  void resendEmailOtp() {
    if (otpSecondsLeft.value > 0) return;
    startOtpTimer();
    Get.snackbar('OTP resent', 'A new code was sent to your email (demo)');
  }

  @override
  void onClose() {
    _otpTimer?.cancel();
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    pan.dispose();
    super.onClose();
  }
}

class DetailsScreen extends StatelessWidget {
  DetailsScreen({super.key});
  final c = Get.put(DetailsController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final stepCtrl = Get.find<StepController>();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
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
              child: SlidingUpPanel(
                minHeight: size.height * 0.88,
                maxHeight: size.height * 0.88,
                isDraggable: false,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                body: const SizedBox.shrink(),
                panel: Obx(
                      () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Padding(
                      key: ValueKey(c.isLoading.value),
                      padding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 8,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: c.isLoading.value
                          ? const _LoadingSkeleton()
                          : _DetailsForm(controller: c),
                    ),
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

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  Widget bar({
    double h = 16,
    double r = 10,
    EdgeInsets m = const EdgeInsets.only(bottom: 12),
  }) =>
      Container(
        height: h,
        margin: m,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(r),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              bar(h: 18, m: const EdgeInsets.only(right: 120, bottom: 16)),
              Row(children: [
                Expanded(child: bar(h: 48)),
                const SizedBox(width: 12),
                Expanded(child: bar(h: 48)),
              ]),
              bar(h: 48),
              bar(h: 48),
              bar(h: 48),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        )
      ],
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({required this.c});
  final DetailsController c;

  InputDecoration _dec(String hint, {Widget? suffix}) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    suffixIcon: suffix,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            ),
            const SizedBox(width: 4),
            const Text(
              'Personal Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('First Name*',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: c.firstName,
                    decoration: _dec('Your first name'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Last Name*',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: c.lastName,
                    decoration: _dec('Your last name'),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Gender*',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 6),
        Obx(() => DropdownButtonFormField<String>(
          value: c.gender.value,
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: (v) => c.gender.value = v,
          decoration: _dec('Select your gender', suffix: const Icon(Icons.expand_more)),
        )),

        const SizedBox(height: 12),

        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Date of Birth*',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 6),
        Obx(() => TextField(
          readOnly: true,
          controller: TextEditingController(text: c.dobLabel),
          decoration: _dec('DD - MM - YYYY',
              suffix: const Icon(Icons.calendar_today_rounded)),
          onTap: () => c.pickDob(context),
        )),

        const SizedBox(height: 12),

        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Your Marital Status *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 6),
        Obx(() => DropdownButtonFormField<String>(
          value: c.maritalStatus.value,
          items: const [
            DropdownMenuItem(value: 'Married', child: Text('Married')),
            DropdownMenuItem(value: 'Unmarried', child: Text('Unmarried')),
          ],
          onChanged: (v) => c.maritalStatus.value = v,
          decoration: _dec('Select', suffix: const Icon(Icons.expand_more)),
        )),

        const SizedBox(height: 8),
      ],
    );
  }
}

class _DetailsForm extends StatelessWidget {
  const _DetailsForm({required this.controller});
  final DetailsController controller;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final stepCtrl = Get.find<StepController>();

    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if (stepCtrl.step.value != DetailsStep.register) {
                      switch (stepCtrl.step.value) {
                        case DetailsStep.offer:
                          return const _PlaceholderBlock(
                            title: 'Offer',
                            subtitle: 'Show loan offers here (demo).',
                          );
                        case DetailsStep.approval:
                          return const _PlaceholderBlock(
                            title: 'Approval',
                            subtitle: 'Show approval summary here (demo).',
                          );
                        case DetailsStep.register:
                          return const SizedBox.shrink();
                      }
                    }

                    switch (c.subStep.value) {
                      case RegisterSubStep.personal:
                        return _RegisterForm(c: c);
                      case RegisterSubStep.emailOtp:
                        return _EmailOtpBlock(c: c);
                      case RegisterSubStep.pan:
                        return _PanBlock(c: c);
                    }
                  }),
                ],
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(4, 10, 4, 20),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A66FF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => c.onContinue(),
              child: Obx(() => Text(
                stepCtrl.step.value == DetailsStep.register
                    ? 'Continue'
                    : stepCtrl.step.value == DetailsStep.offer
                    ? 'Continue'
                    : 'Finish',
                style: const TextStyle(color: Colors.white),
              )),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmailOtpBlock extends StatelessWidget {
  const _EmailOtpBlock({required this.c});
  final DetailsController c;

  InputDecoration _dec(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => c.subStep.value = RegisterSubStep.personal,
            ),
            const SizedBox(width: 4),
            const Text('Personal Email ID',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),

        Center(
          child: Image.asset(
            'assets/images/mail.png',
            height: size.height * 0.20,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),

        const Text('Email ID*',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: c.email,
          keyboardType: TextInputType.emailAddress,
          decoration: _dec('Enter your email ID'),
        ),
        const SizedBox(height: 16),

        const Text('OTP Verification',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),

        SixBoxOtp(
          length: 6,
          onChanged: (code) => c.emailOtp.value = code,
        ),
        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => GestureDetector(
              onTap: c.otpSecondsLeft.value == 0 ? c.resendEmailOtp : null,
              child: Text(
                c.otpSecondsLeft.value == 0
                    ? 'Resend Code'
                    : "Didn't receive it? Resend Code",
                style: TextStyle(
                  color: c.otpSecondsLeft.value == 0
                      ? const Color(0xFF0A66FF)
                      : Colors.black54,
                ),
              ),
            )),
            Obx(() {
              final s = c.otpSecondsLeft.value;
              final mm = (s ~/ 60).toString().padLeft(2, '0');
              final ss = (s % 60).toString().padLeft(2, '0');
              return Text('$mm:$ss',
                  style: const TextStyle(color: Colors.black54));
            }),
          ],
        ),
      ],
    );
  }
}

class _PanBlock extends StatelessWidget {
  const _PanBlock({required this.c});
  final DetailsController c;

  InputDecoration _dec(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => c.subStep.value = RegisterSubStep.emailOtp,
            ),
            const SizedBox(width: 4),
            const Text('Verify PAN Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),

        Center(
          child: Image.asset(
            'assets/images/card.png',
            height: size.height * 0.20,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),

        const Text('Enter Your PAN Number',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextField(
          controller: c.pan,
          textCapitalization: TextCapitalization.characters,
          decoration: _dec('e.g., ABCDE1234F'),
        ),
      ],
    );
  }
}

class _PlaceholderBlock extends StatelessWidget {
  const _PlaceholderBlock({required this.title, required this.subtitle});
  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9EEF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}



class SixBoxOtp extends StatefulWidget {
  const SixBoxOtp({
    super.key,
    required this.onChanged,
    this.length = 6,
    this.spacing = 10,
    this.maxBoxWidth = 50,
    this.minBoxWidth = 30,
  });

  final ValueChanged<String> onChanged;
  final int length;
  final double spacing;
  final double maxBoxWidth;
  final double minBoxWidth;

  @override
  State<SixBoxOtp> createState() => _SixBoxOtpState();
}

class _SixBoxOtpState extends State<SixBoxOtp> {
  late final List<TextEditingController> _c;
  late final List<FocusNode> _n;

  @override
  void initState() {
    super.initState();
    _c = List.generate(widget.length, (_) => TextEditingController());
    _n = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final x in _c) x.dispose();
    for (final x in _n) x.dispose();
    super.dispose();
  }

  void _update() => widget.onChanged(_c.map((x) => x.text).join());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSpacing = widget.spacing * (widget.length - 1);
        double w = (constraints.maxWidth - totalSpacing) / widget.length;

        if (w > widget.maxBoxWidth) w = widget.maxBoxWidth;
        if (w < widget.minBoxWidth) w = widget.minBoxWidth;

        return Row(
          children: List.generate(widget.length, (i) {
            return Container(
              width: w,
              margin: EdgeInsets.only(
                right: i < widget.length - 1 ? widget.spacing : 0,
              ),
              child: TextField(
                controller: _c[i],
                focusNode: _n[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: const InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) {
                  _update();
                  if (v.isNotEmpty && i < widget.length - 1) {
                    _n[i + 1].requestFocus();
                  } else if (v.isEmpty && i > 0) {
                    _n[i - 1].requestFocus();
                  }
                },
              ),
            );
          }),
        );
      },
    );
  }
}
