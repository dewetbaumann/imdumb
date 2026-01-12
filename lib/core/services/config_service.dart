import 'package:flutter/material.dart' show debugPrint;
import 'package:imdumb_dependencies/imdumb_dependencies.dart';

class ConfigService {
  final SharedPreferences _prefs;

  // Configuration keys for SharedPreferences
  static const String _keyWelcomeMessage = 'welcome_message';
  static const String _keyFeatureEnabled = 'feature_x_enabled';

  // Firebase Remote Config settings
  static const Duration _remoteConfigTimeout = Duration(minutes: 1);
  static const Duration _minimumFetchInterval = Duration(hours: 1);

  // Default fallback values
  static const String _defaultWelcomeMessage = 'Welcome to IMDUMB';
  static const String _offlineModeMessage = 'Welcome to IMDUMB (Offline Mode)';
  static const bool _defaultFeatureEnabled = false;

  ConfigService(this._prefs);

  /// Fetches remote configuration from Firebase with automatic fallback.
  ///
  /// **Process**:
  /// 1. Checks Firebase initialization status
  /// 2. Fetches and activates remote config if available
  /// 3. Caches values locally for offline access
  /// 4. Gracefully falls back to cached values on failure
  ///
  /// **Error Handling**: All exceptions caught and logged; app continues functioning.
  Future<void> fetchRemoteConfig() async {
    try {
      if (!_isFirebaseInitialized()) {
        _setOfflineDefaults();
        return;
      }
      await _fetchAndCacheRemoteConfig();
    } catch (e) {
      debugPrint('❌ Error fetching remote config: $e');
      _ensureLocalDefaults();
    }
  }

  /// Verifies Firebase initialization status safely.
  bool _isFirebaseInitialized() {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (e) {
      debugPrint('⚠️  Firebase check failed: $e');
      return false;
    }
  }

  /// Sets offline mode defaults when Firebase unavailable.
  void _setOfflineDefaults() {
    debugPrint('📴 Firebase unavailable. Running in offline mode.');
    _setLocalDefaults(_offlineModeMessage);
  }

  /// Fetches remote config and caches locally.
  Future<void> _fetchAndCacheRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(fetchTimeout: _remoteConfigTimeout, minimumFetchInterval: _minimumFetchInterval),
    );

    await remoteConfig.fetchAndActivate();

    final welcomeMsg = remoteConfig.getString('welcome_message').trim();
    final featureEnabled = remoteConfig.getBool('feature_x_enabled');
    final finalMessage = welcomeMsg.isNotEmpty ? welcomeMsg : _defaultWelcomeMessage;

    await _cacheConfig(finalMessage, featureEnabled);
    debugPrint('✅ Remote config fetched and cached successfully');
  }

  /// Atomically caches config values to SharedPreferences.
  Future<void> _cacheConfig(String welcomeMsg, bool featureEnabled) async {
    await Future.wait([
      _prefs.setString(_keyWelcomeMessage, welcomeMsg),
      _prefs.setBool(_keyFeatureEnabled, featureEnabled),
    ]);
  }

  /// Ensures local defaults are set if config fetch fails.
  void _ensureLocalDefaults() {
    if (!_prefs.containsKey(_keyWelcomeMessage)) {
      _setLocalDefaults(_defaultWelcomeMessage);
    }
  }

  /// Helper to set all defaults atomically.
  void _setLocalDefaults(String message) {
    _prefs.setString(_keyWelcomeMessage, message);
    _prefs.setBool(_keyFeatureEnabled, _defaultFeatureEnabled);
  }

  /// Returns cached welcome message with fallback.
  String get welcomeMessage => _prefs.getString(_keyWelcomeMessage) ?? _defaultWelcomeMessage;

  /// Returns cached feature flag state with fallback.
  bool get isFeatureEnabled => _prefs.getBool(_keyFeatureEnabled) ?? _defaultFeatureEnabled;
}
