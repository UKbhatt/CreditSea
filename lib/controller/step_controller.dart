import 'package:get/get.dart';

enum DetailsStep { register, offer, approval }

class StepController extends GetxController {
  final step = DetailsStep.register.obs;

  int get stepIndex => step.value.index;

  void setStep(DetailsStep s) => step.value = s;
}
