import 'dart:async';

import 'package:flutter/material.dart';

class CepSearch extends StatefulWidget {
  const CepSearch({
    required this.controller,
    required this.cepLabel,
    required this.onSearch,
    super.key,
    this.cepHint = '00000-000',
  });

  final TextEditingController controller;
  final String cepLabel;
  final String cepHint;
  final void Function(String cep) onSearch;

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
      if (cep.length >= 8) {
        widget.onSearch(cep);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.cepLabel,
        hintText: widget.cepHint,
      ),
    );
  }
}
