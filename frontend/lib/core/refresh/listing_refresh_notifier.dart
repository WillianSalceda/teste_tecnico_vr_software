import 'package:flutter/foundation.dart';

/// Notifier para disparar atualização da listagem de listings.
class ListingRefreshNotifier extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}
