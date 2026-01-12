import 'package:imdumb_dependencies/imdumb_dependencies.dart';
import 'package:imdumb/data/datasources/remote/tmdb_datasource.dart';
import 'package:imdumb/data/implementations/external/http_implementation.dart';
import 'package:imdumb/data/repositories/external/http_repository.dart';
import 'package:imdumb/data/repositories/movie_repository_impl.dart';
import 'package:imdumb/domain/repositories/movie_repository.dart';
import 'package:imdumb/domain/usecases/get_genres.dart';
import 'package:imdumb/domain/usecases/get_movie_credits.dart';
import 'package:imdumb/domain/usecases/get_movie_detail.dart';
import 'package:imdumb/domain/usecases/get_movies_by_genre.dart';

// Network
final httpProvider = Provider<IHttp>((ref) => HttpImpl.instance);

// Datasource
final tmdbDataSourceProvider = Provider<TmdbDataSource>((ref) {
  return TmdbDataSourceImpl(ref.read(httpProvider));
});

// Repository
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepositoryImpl(ref.read(tmdbDataSourceProvider));
});

// UseCases
final getGenresProvider = Provider<GetGenres>((ref) {
  return GetGenres(ref.read(movieRepositoryProvider));
});

final getMoviesByGenreProvider = Provider<GetMoviesByGenre>((ref) {
  return GetMoviesByGenre(ref.read(movieRepositoryProvider));
});

final getMovieDetailProvider = Provider<GetMovieDetail>((ref) {
  return GetMovieDetail(ref.read(movieRepositoryProvider));
});

final getMovieCreditsProvider = Provider<GetMovieCredits>((ref) {
  return GetMovieCredits(ref.read(movieRepositoryProvider));
});
