import 'package:flutter/material.dart';

class AddExchangeRateDialog extends StatefulWidget {
  const AddExchangeRateDialog({
    required this.rateLabel,
    required this.saveLabel,
    required this.cancelLabel,
    required this.errorInvalidRate,
    required this.rateHint,
    required this.onSave,
    super.key,
  });

  final String rateLabel;
  final String saveLabel;
  final String cancelLabel;
  final String errorInvalidRate;
  final String rateHint;
  final void Function(double rate) onSave;

  @override
  State<AddExchangeRateDialog> createState() => _AddExchangeRateDialogState();
}

class _AddExchangeRateDialogState extends State<AddExchangeRateDialog> {
  final _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _errorText = widget.errorInvalidRate);
      return;
    }
    final rate = double.tryParse(text.replaceAll(',', '.'));
    if (rate == null || rate <= 0) {
      setState(() => _errorText = widget.errorInvalidRate);
      return;
    }
    widget.onSave(rate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.rateLabel),
      content: TextField(
        controller: _controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: widget.rateLabel,
          hintText: widget.rateHint,
          errorText: _errorText,
        ),
        onChanged: (_) => setState(() => _errorText = null),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelLabel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.saveLabel),
        ),
      ],
    );
  }
}
