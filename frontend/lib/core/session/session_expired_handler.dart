import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/auth/presentation/bloc/auth_bloc.dart';
import '../di/injection.dart';
import '../l10n/app_localizations.dart';
import 'session_expired_notifier.dart';

class SessionExpiredHandler extends StatefulWidget {
  const SessionExpiredHandler({required this.child, super.key});

  final Widget child;

  @override
  State<SessionExpiredHandler> createState() => _SessionExpiredHandlerState();
}

class _SessionExpiredHandlerState extends State<SessionExpiredHandler> {
  @override
  void initState() {
    super.initState();
    final l10n = lookupAppLocalizations(sl<Locale>());
    sl<SessionExpiredNotifier>().setHandler(() {
      if (mounted) {
        context.read<AuthBloc>().add(AuthSessionExpired(l10n.sessionExpired));
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
