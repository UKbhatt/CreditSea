import 'package:flutter/material.dart';

class StepHeader extends StatelessWidget {
  const StepHeader({
    super.key,
    required this.index,
    required this.labels,
    required this.onTap,
  });

  final int index;
  final List<String> labels;
  final ValueChanged<int> onTap;

  Color get _active => const Color(0xFF0A66FF);

  @override
  Widget build(BuildContext context) {
    Widget dot(int i) {
      final done = i < index;
      final active = i == index;
      final color = active || done ? _active : Colors.grey.shade400;
      return GestureDetector(
        onTap: () => onTap(i),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? _active : Colors.white,
                border: Border.all(color: color, width: 2),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${i + 1}',
                style: TextStyle(
                  fontSize: 12,
                  color: active ? Colors.white : color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              labels[i],
              style: TextStyle(
                fontSize: 12,
                color: active || done ? Colors.black87 : Colors.black45,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    Widget line(bool filled) => Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: filled ? _active : Colors.grey.shade300,
      ),
    );

    return Row(
      children: [
        dot(0), line(index >= 1), dot(1), line(index >= 2), dot(2),
      ],
    );
  }
}
