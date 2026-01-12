import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imdumb/domain/models/entities/genre.dart';
import 'package:imdumb/domain/models/entities/movie.dart';
import 'package:imdumb/presentation/providers/home_providers.dart';
import 'package:imdumb/presentation/widgets/category_section.dart';
import 'package:imdumb_dependencies/imdumb_dependencies.dart' show ProviderScope;

void main() {
  testWidgets('CategorySection displays genre name and movies', (WidgetTester tester) async {
    const genre = Genre(id: 1, name: 'Action');
    final movies = [
      const Movie(
        id: 1,
        title: 'Movie 1',
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
        child: const MaterialApp(
          home: Scaffold(body: CategorySection(genre: genre)),
        ),
      ),
    );

    // Initial loading state might be fast or instant if using overrideWith synchronous-like future
    await tester.pumpAndSettle();

    expect(find.text('Action'), findsOneWidget);
    expect(find.text('Movie 1'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('CategorySection displays loading indicator', (WidgetTester tester) async {
    const genre = Genre(id: 1, name: 'Action');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          moviesByGenreProvider(1).overrideWith((ref) async {
            await Future.delayed(const Duration(seconds: 2));
            return [];
          }),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CategorySection(genre: genre)),
        ),
      ),
    );

    await tester.pump(); // Start api call

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Finish
    await tester.pump(const Duration(seconds: 3));
  });
}
