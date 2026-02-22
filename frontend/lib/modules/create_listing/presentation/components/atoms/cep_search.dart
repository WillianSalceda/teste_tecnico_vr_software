import 'package:flutter/material.dart';

class CepSearch extends StatelessWidget {
  const CepSearch({
    required this.controller,
    required this.cepLabel,
    required this.searchLabel,
    required this.onSearch,
    super.key,
    this.cepHint = '00000-000',
  });

  final TextEditingController controller;
  final String cepLabel;
  final String searchLabel;
  final String cepHint;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: cepLabel,
              hintText: cepHint,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onSearch,
          child: Text(searchLabel),
        ),
      ],
    );
  }
}
