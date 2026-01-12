import 'package:dartz/dartz.dart';
import 'package:imdumb/core/errors/failure.dart';
import 'package:imdumb/domain/models/entities/cast.dart';
import 'package:imdumb/domain/models/entities/genre.dart';
import 'package:imdumb/domain/models/entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Genre>>> getGenres();
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(int genreId);
  Future<Either<Failure, Movie>> getMovieDetail(int movieId);
  Future<Either<Failure, List<Cast>>> getMovieCredits(int movieId);
}
