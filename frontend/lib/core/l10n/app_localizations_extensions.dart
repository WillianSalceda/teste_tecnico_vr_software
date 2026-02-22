import 'app_localizations.dart';

extension AppLocalizationsErrorMessage on AppLocalizations {
  String localizeErrorMessage(String raw) {
    switch (raw) {
      case 'Unknown error':
        return unknownError;
      case 'Upload failed':
        return uploadFailed;
      case 'Invalid response: missing token':
        return invalidResponseMissingToken;
      default:
        return raw;
    }
  }
}
