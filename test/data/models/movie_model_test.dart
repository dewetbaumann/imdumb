import 'package:flutter_test/flutter_test.dart';
import 'package:imdumb/data/models/movie_model.dart';
import 'package:imdumb/domain/models/entities/movie.dart';

void main() {
  group('MovieModel', () {
    test('should be a subclass of Movie entity', () {
      final model = MovieModel(
        id: 1,
        title: 'Test Movie',
        posterPath: '/path.jpg',
        backdropPath: '/back.jpg',
        voteAverage: 8.5,
        overview: 'Overview',
        releaseDate: '2023-01-01',
      );
      expect(model, isA<Movie>());
    });

    test('fromJson should return a valid model from JSON', () {
      final json = {
        'id': 1,
        'title': 'Test Movie',
        'poster_path': '/path.jpg',
        'backdrop_path': '/back.jpg',
        'vote_average': 8.5,
        'overview': 'Overview',
        'release_date': '2023-01-01',
      };

      final result = MovieModel.fromJson(json);

      expect(result.id, 1);
      expect(result.title, 'Test Movie');
      expect(result.posterPath, '/path.jpg');
      expect(result.voteAverage, 8.5);
    });

    test('fromJson should handle null fields gracefully', () {
      final json = {'id': 1};

      final result = MovieModel.fromJson(json);

      expect(result.id, 1);
      expect(result.title, '');
      expect(result.voteAverage, 0.0);
    });
  });
}
