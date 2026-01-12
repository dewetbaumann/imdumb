import 'package:dartz/dartz.dart';
import 'package:imdumb/core/errors/failure.dart';
import 'package:imdumb/domain/models/entities/cast.dart';
import 'package:imdumb/domain/repositories/movie_repository.dart';

class GetMovieCredits {
  final MovieRepository repository;

  GetMovieCredits(this.repository);

  Future<Either<Failure, List<Cast>>> call(int movieId) {
    return repository.getMovieCredits(movieId);
  }
}
