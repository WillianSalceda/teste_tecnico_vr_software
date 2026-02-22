class SessionExpiredNotifier {
  SessionExpiredNotifier();

  void Function()? _handler;

  void setHandler(void Function()? handler) {
    _handler = handler;
  }

  void notify() {
    _handler?.call();
  }
}
