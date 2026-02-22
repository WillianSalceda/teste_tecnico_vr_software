import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/session.dart';

abstract class IAuthLocalStorage {
  Future<void> saveSession(Session session);

  Future<void> clearSession();

  Future<Session?> getSession();
}

const _keySession = 'auth_session';

class AuthLocalStorage implements IAuthLocalStorage {
  AuthLocalStorage(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> saveSession(Session session) async {
    final json = jsonEncode({
      'token': session.token,
      'username': session.username,
    });
    await _prefs.setString(_keySession, json);
  }

  @override
  Future<void> clearSession() async {
    await _prefs.remove(_keySession);
  }

  @override
  Future<Session?> getSession() async {
    final json = _prefs.getString(_keySession);
    if (json == null) return null;
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      final token = map['token'] as String?;
      final username = map['username'] as String?;
      if (token == null || token.isEmpty) return null;
      return Session(token: token, username: username ?? '');
    } on Object catch (_) {
      return null;
    }
  }
}
