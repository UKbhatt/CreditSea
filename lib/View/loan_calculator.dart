import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart' ;
import '../controller/step_controller.dart';

class LoanCalculatorPage extends StatefulWidget {
  const LoanCalculatorPage({super.key});
  @override
  State<LoanCalculatorPage> createState() => _LoanCalculatorPageState();
}

class _LoanCalculatorPageState extends State<LoanCalculatorPage> {
  final _panelCtrl = PanelController();

  final _currency =
  NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  double _amount = 30000;
  final double _minAmount = 2000;
  final double _maxAmount = 100000;

  double _days = 40;
  late String _purpose ;
  final double _minDays = 20;
  final double _maxDays = 45;

  final double _interestPerDayPercent = 1;
  final double _processingFeePercent = 10;

  double get _principal => _amount;
  double get _interestPercentTotal => _interestPerDayPercent * _days;
  double get _interestAmount => (_principal * _interestPercentTotal) / 100.0;
  double get _processingFee => (_principal * _processingFeePercent) / 100.0;
  double get _totalPayable => _principal + _interestAmount + _processingFee;

  String _fmtCurrency(num v) => _currency.format(v);
  String _fmtPercent(num v) =>
      "${v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2)}%";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const double headerHeight = 80;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          SafeArea(
            child: SizedBox(
              height: headerHeight,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/img_3.png", height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Credit",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        "Sea",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w200,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SlidingUpPanel(
            controller: _panelCtrl,
            isDraggable: false,
            minHeight: size.height * 0.85,
            maxHeight: size.height * 0.85,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(22)),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 14,
                offset: Offset(0, -2),
              )
            ],
            panelBuilder: (sc) => ListView(
              controller: sc,
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 18),
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Apply for loan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  "We’ve calculated your loan eligibility. Select your preferred loan amount and tenure.",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _InfoBadge(
                      label:
                      "Interest Per Day ${_fmtPercent(_interestPerDayPercent)}",
                      icon: Icons.percent_rounded,
                    ),
                    _InfoBadge(
                      label: "Processing Fee ${_fmtPercent(_processingFeePercent)}",
                      icon: Icons.receipt_long_outlined,

                    ),
                  ],
                ),
                const SizedBox(height: 18),

                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter purpose of loan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _purpose = value;
                    });
                  },
                ),
                const SizedBox(height: 18),
                _RowLabel(left: "Principal Amount", right: _fmtCurrency(_amount)),
                _BlueSliderField(
                  value: _amount,
                  min: _minAmount,
                  max: _maxAmount,
                  divisions: (_maxAmount - _minAmount).toInt() ~/ 1000,
                  onChanged: (v) => setState(() => _amount = v),
                ),
                const SizedBox(height: 8),

                _RowLabel(left: "Tenure", right: "${_days.round()} Days"),
                _BlueSliderField(
                  value: _days,
                  min: _minDays,
                  max: _maxDays,
                  divisions: (_maxDays - _minDays).toInt(),
                  startLabel: "${_minDays.round()} Days",
                  endLabel: "${_maxDays.round()} Days",
                  onChanged: (v) => setState(() => _days = v),
                ),
                const SizedBox(height: 12),

                _SummaryCard(
                  principal: _fmtCurrency(_principal),
                  interestRateLabel: _fmtPercent(_interestPercentTotal),
                  interestAmount: _fmtCurrency(_interestAmount),
                  total: _fmtCurrency(_totalPayable),
                ),

                const SizedBox(height: 10),
                Text(
                  "Thank you for choosing CreditSea. Please accept to proceed with the loan details.",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          final step = Get.find<StepController>();
                          step.setStep(DetailsStep.offer);
                          Get.offAllNamed('/offer');
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: const Text("Apply"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle() => TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.grey.shade800,
    fontSize: 13.5,
  );
}

class _BlueSliderField extends StatelessWidget {
  final double value, min, max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final String? startLabel, endLabel;
  const _BlueSliderField({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
    this.startLabel,
    this.endLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue,
            inactiveTrackColor: Colors.blue.withOpacity(.2),
            thumbColor: Colors.blue,
            overlayColor: Colors.blue.withOpacity(.15),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        if (startLabel != null || endLabel != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(startLabel ?? "",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                Text(endLabel ?? "",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
      ],
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoBadge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: primary.withOpacity(.08),
        border: Border.all(color: primary.withOpacity(.18)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: primary),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: primary, fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final T? value;
  final List<String> items;
  final String hint;
  final ValueChanged<T?> onChanged;
  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: items
          .map((e) => DropdownMenuItem<T>(value: e as T, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _RowLabel extends StatelessWidget {
  final String left, right;
  const _RowLabel({required this.left, required this.right});
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(left,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(right,
                style: TextStyle(
                    color: primary, fontWeight: FontWeight.w700, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String principal, interestRateLabel, interestAmount, total;
  const _SummaryCard({
    required this.principal,
    required this.interestRateLabel,
    required this.interestAmount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final border = Border.all(color: Colors.grey.shade200);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: border,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _summaryRow("Principle Amount", principal),
          const SizedBox(height: 8),
          _summaryRow("Interest ($interestRateLabel)", interestAmount),
          const Divider(height: 18),
          _summaryRow("Total Payable", total, isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String k, String v, {bool isBold = false}) {
    final styleKey =
    TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w600);
    final styleVal = TextStyle(
      color: isBold ? const Color(0xFF1E63F3) : Colors.grey.shade900,
      fontSize: isBold ? 14 : 13,
      fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
    );
    return Row(
      children: [
        Expanded(child: Text(k, style: styleKey)),
        Text(v, style: styleVal),
      ],
    );
  }
}
