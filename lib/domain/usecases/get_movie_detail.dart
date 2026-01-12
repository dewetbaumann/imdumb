import 'package:dartz/dartz.dart';
import 'package:imdumb/core/errors/failure.dart';
import 'package:imdumb/domain/models/entities/movie.dart';
import 'package:imdumb/domain/repositories/movie_repository.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, Movie>> call(int movieId) {
    return repository.getMovieDetail(movieId);
  }
}
