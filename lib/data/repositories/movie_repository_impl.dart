import 'package:imdumb_dependencies/imdumb_dependencies.dart';
import 'package:imdumb/core/errors/failure.dart';
import 'package:imdumb/core/errors/http_exception.dart';
import 'package:imdumb/data/datasources/remote/tmdb_datasource.dart';
import 'package:imdumb/domain/models/entities/cast.dart';
import 'package:imdumb/domain/models/entities/genre.dart';
import 'package:imdumb/domain/models/entities/movie.dart';
import 'package:imdumb/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  // SOLID: Dependency Inversion Principle (DIP)
  // We depend on abstraction (TmdbDataSource interface) not concretion (TmdbDataSourceImpl)
  final TmdbDataSource _remoteDataSource;

  MovieRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Genre>>> getGenres() async {
    try {
      final result = await _remoteDataSource.getGenres();
      return Right(result);
    } on HttpExceptionModel catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(int genreId) async {
    try {
      final result = await _remoteDataSource.getMoviesByGenre(genreId);
      return Right(result);
    } on HttpExceptionModel catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetail(int movieId) async {
    try {
      final result = await _remoteDataSource.getMovieDetail(movieId);
      return Right(result);
    } on HttpExceptionModel catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Cast>>> getMovieCredits(int movieId) async {
    try {
      final result = await _remoteDataSource.getMovieCredits(movieId);
      return Right(result);
    } on HttpExceptionModel catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
