import 'package:flutter/material.dart';

import '../../../../../core/l10n/app_l10n.dart';
import '../atoms/address_fields_row.dart';
import '../atoms/cep_search.dart';
import '../atoms/text_field_molecule.dart';

class CreateListingAddressForm extends StatelessWidget {
  const CreateListingAddressForm({
    required this.cepController,
    required this.streetController,
    required this.numberController,
    required this.complementController,
    required this.neighborhoodController,
    required this.cityController,
    required this.stateController,
    required this.l10n,
    required this.onSearchCep,
    super.key,
  });

  final TextEditingController cepController;
  final TextEditingController streetController;
  final TextEditingController numberController;
  final TextEditingController complementController;
  final TextEditingController neighborhoodController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final AppL10n l10n;
  final void Function(String cep) onSearchCep;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.address, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        CepSearch(
          controller: cepController,
          cepLabel: l10n.cep,
          onSearch: onSearchCep,
        ),
        const SizedBox(height: 8),
        TextFieldMolecule(
          controller: streetController,
          label: l10n.street,
        ),
        const SizedBox(height: 8),
        AddressFieldsRow(
          firstController: numberController,
          firstLabel: l10n.number,
          secondController: complementController,
          secondLabel: l10n.complement,
          firstFlex: 1,
          secondFlex: 2,
        ),
        const SizedBox(height: 8),
        TextFieldMolecule(
          controller: neighborhoodController,
          label: l10n.neighborhood,
        ),
        const SizedBox(height: 8),
        AddressFieldsRow(
          firstController: cityController,
          firstLabel: l10n.city,
          secondController: stateController,
          secondLabel: l10n.state,
          firstFlex: 2,
          secondFlex: 1,
        ),
      ],
    );
  }
}
