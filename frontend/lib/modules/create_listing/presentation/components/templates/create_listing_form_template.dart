import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/l10n/app_l10n.dart';
import '../../bloc/cep_bloc.dart';
import '../../bloc/create_listing_bloc.dart';
import '../atoms/submit_button.dart';
import '../atoms/type_selector.dart';
import '../atoms/value_input.dart';
import '../molecules/create_listing_address_form.dart';
import '../molecules/image_picker.dart';

class CreateListingFormTemplate extends StatelessWidget {
  const CreateListingFormTemplate({
    required this.l10n,
    required this.resolveError,
    required this.state,
    required this.createListingBloc,
    super.key,
  });

  final AppL10n l10n;
  final String Function(String?) resolveError;
  final CreateListingFormState state;
  final CreateListingBloc createListingBloc;

  @override
  Widget build(BuildContext context) {
    final bloc = createListingBloc;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TypeSelector(
                  label: l10n.type,
                  saleLabel: l10n.sale,
                  rentLabel: l10n.rent,
                  selectedType: state.type,
                  onTypeChanged: (t) => bloc.add(CreateListingTypeChanged(t)),
                ),
                const SizedBox(height: 16),
                ValueInput(
                  label: l10n.valueBRL,
                  controller: bloc.valueController,
                  errorText: state.errorMessage == 'invalidValue'
                      ? resolveError(state.errorMessage)
                      : null,
                ),
                const SizedBox(height: 16),
                if (state.errorMessage == 'requiredField')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      resolveError(state.errorMessage),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                if (state.errorMessage == 'requiredField')
                  const SizedBox(height: 8),
                CreateListingAddressForm(
                  cepController: bloc.cepController,
                  streetController: bloc.streetController,
                  numberController: bloc.numberController,
                  complementController: bloc.complementController,
                  neighborhoodController: bloc.neighborhoodController,
                  cityController: bloc.cityController,
                  stateController: bloc.stateController,
                  l10n: l10n,
                  onSearchCep: (cep) {
                    context.read<CepBloc>().add(CepLookupRequested(cep));
                  },
                ),
                const SizedBox(height: 16),
                CreateListingImagePicker(
                  label: l10n.image,
                  noImageLabel: l10n.noImage,
                  hasImage: state.imagePath != null,
                  imagePath: state.imagePath,
                  onPick: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      allowMultiple: false,
                    );
                    final path = result?.files.singleOrNull?.path;
                    if (path != null) {
                      bloc.add(CreateListingImagePathChanged(path));
                    }
                  },
                ),
                const SizedBox(height: 24),
                SubmitButton(
                  label: l10n.save,
                  enabled: !state.isLoading,
                  onPressed: () => bloc.add(const CreateListingSubmitted()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
