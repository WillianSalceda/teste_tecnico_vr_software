import 'dart:async';

import 'package:flutter/material.dart';

class CepSearch extends StatefulWidget {
  const CepSearch({
    required this.controller,
    required this.cepLabel,
    required this.onSearch,
    required this.requiredFieldMessage,
    required this.invalidCepMessage,
    super.key,
    this.cepHint = '00000-000',
  });

  final TextEditingController controller;
  final String cepLabel;
  final String cepHint;
  final void Function(String cep) onSearch;
  final String requiredFieldMessage;
  final String invalidCepMessage;

  @override
  State<CepSearch> createState() => _CepSearchState();
}

class _CepSearchState extends State<CepSearch> {
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onCepChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onCepChanged);
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onCepChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final cep = widget.controller.text.trim();
      final digitsOnly = cep.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length == 8) {
        widget.onSearch(digitsOnly);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.cepLabel,
        hintText: widget.cepHint,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return widget.requiredFieldMessage;
        }
        final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
        if (digitsOnly.length != 8) {
          return widget.invalidCepMessage;
        }
        return null;
      },
    );
  }
}
