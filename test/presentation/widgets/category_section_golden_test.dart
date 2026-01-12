import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imdumb/domain/models/entities/genre.dart';
import 'package:imdumb/domain/models/entities/movie.dart';
import 'package:imdumb/presentation/providers/home_providers.dart';
import 'package:imdumb/presentation/widgets/category_section.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
      MethodCall methodCall,
    ) async {
      return '.';
    });
  });

  testWidgets('Golden test for CategorySection', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(600, 800);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    const genre = Genre(id: 1, name: 'Action Movies');
    final movies = [
      const Movie(
        id: 1,
        title: 'Movie One',
        posterPath: '/p1.jpg',
        backdropPath: '/b1.jpg',
        voteAverage: 8.5,
        overview: 'First movie overview',
        releaseDate: '2023-01-01',
      ),
      const Movie(
        id: 2,
        title: 'Movie Two',
        posterPath: '/p2.jpg',
        backdropPath: '/b2.jpg',
        voteAverage: 7.8,
        overview: 'Second movie overview',
        releaseDate: '2023-02-01',
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [moviesByGenreProvider(1).overrideWithValue(AsyncValue.data(movies))],
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
              displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
              titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
              titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
              bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
              bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
              bodySmall: TextStyle(fontSize: 12, color: Colors.black87),
              labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
          home: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(child: CategorySection(genre: genre)),
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );

    // Wait for async operations
    await tester.pumpAndSettle();

    // Capture golden file
    await expectLater(find.byType(CategorySection), matchesGoldenFile('goldens/category_section.png'));
  });
}
