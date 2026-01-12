import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdumb/data/implementations/external/http_implementation.dart';
import 'package:imdumb/domain/providers/global_riverpod.dart';
import 'package:imdumb/presentation/providers/app_config_provider.dart';
import 'package:imdumb/presentation/screens/home/home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Initialize HttpImpl
    HttpImpl.initialize(
      context: context,
      read: ref.read,
      version: '1.0.0',
      onCall: () async {
        await Future.delayed(Duration.zero);
        if (mounted) ref.read(globalProvider.notifier).setProcessingHTTPRequest(true);
      },
      onDone: () async {
        await Future.delayed(Duration.zero);
        if (mounted) ref.read(globalProvider.notifier).setProcessingHTTPRequest(false);
      },
      onFail: () async {
        await Future.delayed(Duration.zero);
        if (mounted) ref.read(globalProvider.notifier).setProcessingHTTPRequest(false);
      },
    );

    // Start initialization
    // We add a minimum delay to show logo
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ref.read(splashLoadingProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final splashState = ref.watch(splashLoadingProvider);

    // Listen to changes
    ref.listen(splashLoadingProvider, (previous, next) {
      if (next is AsyncData) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.movie_filter_rounded, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text('IMDUMB', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            splashState.when(
              data: (_) => const CircularProgressIndicator(), // Should define navigation already
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
            ),
          ],
        ),
      ),
    );
  }
}
