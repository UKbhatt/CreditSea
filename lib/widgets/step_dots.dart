import 'package:flutter/material.dart';

class StepDots extends StatelessWidget {
  const StepDots({super.key, required this.count, required this.index});
  final int count, index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6,
          width: active ? 18 : 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(active ? 0.95 : 0.5),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
