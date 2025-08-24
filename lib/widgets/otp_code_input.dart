import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpCodeInput extends StatefulWidget {
  const OtpCodeInput({
    super.key,
    this.length = 4,
    required this.onChanged,
    required this.onCompleted,
    this.boxSize = 54,
    this.boxGap = 12,
  });
  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final double boxSize, boxGap;

  @override
  State<OtpCodeInput> createState() => _OtpCodeInputState();
}

class _OtpCodeInputState extends State<OtpCodeInput> {
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
    // dispose
    for (final x in _c) x.dispose();
    for (final x in _n) x.dispose();
    super.dispose();
  }

  void _focusFirstEmpty() {
    for (int i = 0; i < widget.length; i++) {
      if (_c[i].text.isEmpty) {
        _n[i].requestFocus();
        return;
      }
    }
    _n.last.requestFocus();
  }

  void _pasteFill(String text) {
    final d = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (d.isEmpty) return;
    for (int i = 0; i < widget.length; i++) {
      _c[i].text = i < d.length ? d[i] : '';
    }
    final code = _code();
    widget.onChanged(code);
    if (code.length == widget.length) widget.onCompleted(code);
  }

  String _code() => _c.map((x) => x.text).join();

  KeyEventResult _onKey(int i, KeyEvent e) {
    if (e is KeyDownEvent && e.logicalKey == LogicalKeyboardKey.backspace) {
      if (_c[i].text.isEmpty && i > 0) {
        _n[i - 1].requestFocus();
        _c[i - 1].text = '';
        widget.onChanged(_code());
      }
    }
    return KeyEventResult.ignored;
  }

  void _onChanged(int i, String v) {
    if (v.length > 1) { _pasteFill(v); return; }
    if (v.isNotEmpty && i < widget.length - 1) _n[i + 1].requestFocus();
    widget.onChanged(_code());
    final code = _code();
    if (code.length == widget.length) widget.onCompleted(code);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _focusFirstEmpty,
      behavior: HitTestBehavior.translucent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.length, (i) {
          return Container(
            width: widget.boxSize,
            margin: EdgeInsets.only(right: i < widget.length - 1 ? widget.boxGap : 0),
            child: Focus(
              onKeyEvent: (node, e) => _onKey(i, e),
              child: TextField(
                controller: _c[i],
                focusNode: _n[i],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: '•',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                onChanged: (v) => _onChanged(i, v),
              ),
            ),
          );
        }),
      ),
    );
  }
}
class SixBoxOtp extends StatefulWidget {
  const SixBoxOtp({required this.onChanged, this.length = 6});
  final ValueChanged<String> onChanged;
  final int length;
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
  void dispose() { for (final x in _c) x.dispose(); for (final x in _n) x.dispose(); super.dispose(); }
  void _update() => widget.onChanged(_c.map((x)=>x.text).join());
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(widget.length, (i) {
        return Container(
          width: 44,
          margin: EdgeInsets.only(right: i < widget.length - 1 ? 10 : 0),
          child: TextField(
            controller: _c[i],
            focusNode: _n[i],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: const InputDecoration(counterText: '', border: OutlineInputBorder()),
            onChanged: (v) {
              _update();
              if (v.isNotEmpty && i < widget.length - 1) _n[i + 1].requestFocus();
              if (v.isEmpty && i > 0) _n[i - 1].requestFocus();
            },
          ),
        );
      }),
    );
  }
}
