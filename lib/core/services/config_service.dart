import 'package:flutter/material.dart' show debugPrint;
import 'package:imdumb_dependencies/imdumb_dependencies.dart';

class ConfigService {
  final SharedPreferences _prefs;

  ConfigService(this._prefs);

  static const String _keyWelcomeMessage = 'welcome_message';
  static const String _keyFeatureEnabled = 'feature_x_enabled';

  Future<void> fetchRemoteConfig() async {
    try {
      // NOTE: Firebase initialization requires google-services.json which might not be present.
      // We wrap this in try-catch to allow app to run in "offline/mock" mode if firebase fails.
      if (Firebase.apps.isEmpty) {
        // await Firebase.initializeApp(); // Commented out to prevent crash without config file
        debugPrint('Firebase not initialized (missing google-services.json?). Skipping Remote Config.');
        return;
      }

      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(fetchTimeout: const Duration(minutes: 1), minimumFetchInterval: const Duration(hours: 1)),
      );

      await remoteConfig.fetchAndActivate();

      final welcomeMsg = remoteConfig.getString('welcome_message');
      final featureEnabled = remoteConfig.getBool('feature_x_enabled');

      await _prefs.setString(_keyWelcomeMessage, welcomeMsg.isNotEmpty ? welcomeMsg : 'Welcome to IMDUMB (Local)');
      await _prefs.setBool(_keyFeatureEnabled, featureEnabled);
    } catch (e) {
      debugPrint('Error fetching remote config: $e');
      // Fallback
      if (!_prefs.containsKey(_keyWelcomeMessage)) {
        await _prefs.setString(_keyWelcomeMessage, 'Welcome to IMDUMB (Default)');
      }
    }
  }

  String get welcomeMessage => _prefs.getString(_keyWelcomeMessage) ?? 'Welcome';
}
