import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../core/l10n/app_localizations_extensions.dart';
import '../../bloc/cep_bloc.dart';
import '../../bloc/create_listing_bloc.dart';
import '../atoms/submit_button.dart';
import '../atoms/type_selector.dart';
import '../atoms/value_input.dart';
import '../molecules/create_listing_address_form.dart';
import '../molecules/image_picker.dart';

class CreateListingFormTemplate extends StatefulWidget {
  const CreateListingFormTemplate({
    required this.l10n,
    required this.state,
    required this.createListingBloc,
    super.key,
  });

  final AppLocalizations l10n;
  final CreateListingFormState state;
  final CreateListingBloc createListingBloc;

  @override
  State<CreateListingFormTemplate> createState() =>
      _CreateListingFormTemplateState();
}

class _CreateListingFormTemplateState extends State<CreateListingFormTemplate> {
  final _formKey = GlobalKey<FormState>();

  String _resolveErrorMessage(String key, AppLocalizations l10n) {
    switch (key) {
      case 'invalidValue':
        return l10n.invalidValue;
      case 'invalidType':
        return l10n.invalidType;
      default:
        return l10n.localizeErrorMessage(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = widget.createListingBloc;
    final l10n = widget.l10n;
    final state = widget.state;

    return BlocListener<CreateListingBloc, CreateListingState>(
      listenWhen: (previous, current) =>
          current is CreateListingFormState && current.addressFilledFromCep,
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _formKey.currentState?.validate();
          bloc.add(const AddressRevalidationHandled());
        });
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _resolveErrorMessage(state.errorMessage!, l10n),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TypeSelector(
                        label: l10n.type,
                        saleLabel: l10n.sale,
                        rentLabel: l10n.rent,
                        selectedType: state.type,
                        onTypeChanged: (t) =>
                            bloc.add(CreateListingTypeChanged(t)),
                      ),
                      const SizedBox(height: 16),
                      ValueInput(
                        label: l10n.valueBRL,
                        controller: bloc.valueController,
                        requiredFieldMessage: l10n.requiredField,
                        invalidValueMessage: l10n.invalidValue,
                      ),
                      const SizedBox(height: 16),
                      CreateListingAddressForm(
                        cepController: bloc.cepController,
                        streetController: bloc.streetController,
                        numberController: bloc.numberController,
                        complementController: bloc.complementController,
                        neighborhoodController: bloc.neighborhoodController,
                        cityController: bloc.cityController,
                        stateController: bloc.stateController,
                        l10n: l10n,
                        requiredFieldMessage: l10n.requiredField,
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
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            bloc.add(const CreateListingSubmitted());
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
