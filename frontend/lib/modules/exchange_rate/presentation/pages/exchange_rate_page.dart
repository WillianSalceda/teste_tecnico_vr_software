import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_l10n.dart';
import '../bloc/exchange_rate_bloc.dart';
import '../components/add_exchange_rate_dialog.dart';
import '../components/exchange_rate_tile.dart';

class ExchangeRatePage extends StatelessWidget {
  const ExchangeRatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = sl<Locale>();
    final l10n = AppL10n(locale: locale);

    return BlocProvider<ExchangeRateBloc>(
      create: (_) {
        final bloc = sl<ExchangeRateBloc>();
        bloc.add(const ExchangeRateLoadRequested());
        return bloc;
      },
      child: _ExchangeRateContent(l10n: l10n),
    );
  }
}

class _ExchangeRateContent extends StatelessWidget {
  const _ExchangeRateContent({required this.l10n});

  final AppL10n l10n;

  void _showAddDialog(BuildContext context, ExchangeRateBloc bloc) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (ctx) => AddExchangeRateDialog(
          rateLabel: l10n.rate,
          saveLabel: l10n.save,
          cancelLabel: l10n.cancel,
          errorInvalidRate: l10n.invalidRate,
          onSave: (rate) => bloc.add(ExchangeRateCreateRequested(rate)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exchangeRates),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ExchangeRateBloc>().add(
              const ExchangeRateLoadRequested(),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ExchangeRateBloc, ExchangeRateState>(
        listenWhen: (prev, curr) =>
            prev is ExchangeRateCreateLoading && curr is ExchangeRateLoaded,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.exchangeRateCreatedSuccess)),
          );
        },
        builder: (context, state) {
          if (state is ExchangeRateLoading ||
              state is ExchangeRateCreateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ExchangeRateError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.read<ExchangeRateBloc>().add(
                      const ExchangeRateLoadRequested(),
                    ),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }
          if (state is ExchangeRateLoaded) {
            final rates = state.exchangeRates;
            if (rates.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.noExchangeRates),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _showAddDialog(
                        context,
                        context.read<ExchangeRateBloc>(),
                      ),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addExchangeRate),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: rates.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ExchangeRateTile(exchangeRate: rates[index]),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
