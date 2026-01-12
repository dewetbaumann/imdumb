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
    const genre = Genre(id: 1, name: 'Golden Action');
    final movies = [
      const Movie(
        id: 1,
        title: 'Golden Movie',
        posterPath: '/p1.jpg',
        backdropPath: '/b1.jpg',
        voteAverage: 8.0,
        overview: 'Overview 1',
        releaseDate: '2023-01-01',
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          moviesByGenreProvider(1).overrideWith((ref) async {
            return movies;
          }),
        ],
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto'), // Intentar usar una fuente legible si está disponible
          home: Scaffold(body: CategorySection(genre: genre)),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Precaching images is usually required for NetworkImages in golden tests to avoid placeholders or errors.
    // Since we mock the provider, we don't have real network but CachedNetworkImage might try.
    // For Golden tests, it's common to mock image providers or use a special test wrapper.
    // Here we mainly verify structure.

    await expectLater(find.byType(CategorySection), matchesGoldenFile('goldens/category_section.png'));
  });
}
