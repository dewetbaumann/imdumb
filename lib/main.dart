import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:imdumb_dependencies/imdumb_dependencies.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:imdumb/presentation/providers/app_config_provider.dart';
import 'package:imdumb/presentation/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final packageInfo = await PackageInfo.fromPlatform();

  // Try Initialize Firebase (Mocked for this challenge environment)
  // try {
  //   await Firebase.initializeApp();
  // } catch (e) {
  //   print("Firebase Init skipped: $e");
  // }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        packageInfoProvider.overrideWithValue(packageInfo),
      ],
      child: const ImDumbApp(),
    ),
  );
}

class ImDumbApp extends StatelessWidget {
  const ImDumbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'IMDUMB',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true, scaffoldBackgroundColor: Colors.white),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return FlavorBanner(child: child ?? const SizedBox());
        },
      ),
    );
  }
}

class FlavorBanner extends ConsumerWidget {
  final Widget child;
  const FlavorBanner({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = ref.watch(packageInfoProvider);
    final packageName = packageInfo.packageName;
    final isQA = packageName.endsWith('.qa');
    if (!isQA) return child;

    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Banner(
        location: BannerLocation.topStart,
        message: 'QA',
        color: Colors.red.withValues(alpha: .6),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0, letterSpacing: 1.0),
        textDirection: ui.TextDirection.ltr,
        child: child,
      ),
    );
  }
}
