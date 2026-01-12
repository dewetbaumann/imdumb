import 'package:dartz/dartz.dart';
import 'package:imdumb/core/errors/failure.dart';
import 'package:imdumb/domain/models/entities/genre.dart';
import 'package:imdumb/domain/repositories/movie_repository.dart';

class GetGenres {
  final MovieRepository repository;

  GetGenres(this.repository);

  Future<Either<Failure, List<Genre>>> call() {
    return repository.getGenres();
  }
}
