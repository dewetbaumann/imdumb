import 'package:dartz/dartz.dart';
import 'package:imdumb/core/errors/failure.dart';
import 'package:imdumb/domain/models/entities/movie.dart';
import 'package:imdumb/domain/repositories/movie_repository.dart';

class GetMoviesByGenre {
  final MovieRepository repository;

  GetMoviesByGenre(this.repository);

  Future<Either<Failure, List<Movie>>> call(int genreId) {
    return repository.getMoviesByGenre(genreId);
  }
}
