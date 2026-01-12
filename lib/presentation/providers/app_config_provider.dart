import 'package:imdumb/core/services/config_service.dart';
import 'package:imdumb_dependencies/imdumb_dependencies.dart';
import 'package:package_info_plus/package_info_plus.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize this in main.dart');
});

final packageInfoProvider = Provider<PackageInfo>((ref) {
  throw UnimplementedError('Initialize this in main.dart');
});

final configServiceProvider = Provider<ConfigService>((ref) {
  return ConfigService(ref.read(sharedPreferencesProvider));
});

final splashLoadingProvider = FutureProvider<void>((ref) async {
  final configService = ref.read(configServiceProvider);
  await configService.fetchRemoteConfig();
});
