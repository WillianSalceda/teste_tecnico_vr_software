import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_l10n.dart';
import '../bloc/cep_bloc.dart';
import '../bloc/create_listing_bloc.dart';
import '../components/templates/create_listing_form_template.dart';

class CreateListingPage extends StatelessWidget {
  const CreateListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = sl<Locale>();
    final l10n = AppL10n(locale: locale);

    return MultiBlocProvider(
      providers: [
        BlocProvider<CepBloc>(create: (_) => sl<CepBloc>()),
        BlocProvider<CreateListingBloc>(create: (_) => sl<CreateListingBloc>()),
      ],
      child: _CreateListingContent(l10n: l10n),
    );
  }
}

class _CreateListingContent extends StatelessWidget {
  const _CreateListingContent({required this.l10n});

  final AppL10n l10n;

  String _resolveError(String? key) {
    if (key == null) return '';
    switch (key) {
      case 'requiredField':
        return l10n.requiredField;
      case 'invalidValue':
        return l10n.invalidValue;
      case 'invalidType':
        return l10n.invalidType;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CepBloc, CepState>(
      listener: (context, cepState) {
        if (cepState is CepLoaded) {
          context.read<CreateListingBloc>().add(
            CepLookupSucceeded(cepState.address),
          );
        }
      },
      child: BlocConsumer<CreateListingBloc, CreateListingState>(
        listenWhen: (previous, current) =>
            current is CreateListingFormState && (current).success ||
            current is CreateListingNavigateState,
        listener: (context, state) {
          if (state is CreateListingFormState && state.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.listingCreatedSuccess)),
            );
          }
          if (state is CreateListingNavigateState) {
            context.go(state.route);
            context.read<CreateListingBloc>().add(const NavigationHandled());
          }
        },
        buildWhen: (prev, curr) => curr is CreateListingFormState,
        builder: (context, state) {
          final formState = state as CreateListingFormState;
          final bloc = context.read<CreateListingBloc>();

          return Scaffold(
            appBar: AppBar(title: Text(l10n.createListing)),
            body: formState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : CreateListingFormTemplate(
                    l10n: l10n,
                    resolveError: _resolveError,
                    state: formState,
                    createListingBloc: bloc,
                  ),
          );
        },
      ),
    );
  }
}
