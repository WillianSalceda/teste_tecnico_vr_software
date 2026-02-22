import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_l10n.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/exchange_rate.dart';
import '../bloc/exchange_rate_bloc.dart';
import '../components/add_exchange_rate_dialog.dart';

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
      backgroundColor: AppTheme.light.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.exchangeRates),
      ),
      body: BlocConsumer<ExchangeRateBloc, ExchangeRateState>(
        listenWhen: (prev, curr) =>
            prev is ExchangeRateCreateLoading && curr is ExchangeRateLoaded,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.exchangeRateCreatedSuccess),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        builder: (context, state) {
          final addButtonBottomBar = _AddButtonBottomBar(
            label: l10n.addExchangeRate,
            disabled:
                state is ExchangeRateLoading ||
                state is ExchangeRateCreateLoading,
            onPressed: () => _showAddDialog(
              context,
              context.read<ExchangeRateBloc>(),
            ),
          );

          if (state is ExchangeRateLoading ||
              state is ExchangeRateCreateLoading) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                addButtonBottomBar,
              ],
            );
          }
          if (state is ExchangeRateError) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(48),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 64,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: () =>
                                context.read<ExchangeRateBloc>().add(
                                  const ExchangeRateLoadRequested(),
                                ),
                            icon: const Icon(Icons.refresh_rounded, size: 20),
                            label: Text(l10n.retry),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                addButtonBottomBar,
              ],
            );
          }
          if (state is ExchangeRateLoaded) {
            final rates = state.exchangeRates;
            if (rates.isEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D9488).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.currency_exchange_rounded,
                                size: 64,
                                color: Color(0xFF0D9488),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.noExchangeRates,
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  addButtonBottomBar,
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                    itemCount: rates.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ExchangeRateCard(exchangeRate: rates[index]),
                    ),
                  ),
                ),
                addButtonBottomBar,
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _AddButtonBottomBar extends StatelessWidget {
  const _AddButtonBottomBar({
    required this.label,
    required this.disabled,
    required this.onPressed,
  });

  final String label;
  final bool disabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: disabled ? null : onPressed,
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(label),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExchangeRateCard extends StatelessWidget {
  const _ExchangeRateCard({required this.exchangeRate});

  final ExchangeRate exchangeRate;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.currency_exchange_rounded,
                color: Color(0xFF0D9488),
                size: 24,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1 BRL = ${exchangeRate.rate.toStringAsFixed(4)} USD',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(exchangeRate.validFrom),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
