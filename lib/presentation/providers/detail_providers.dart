import 'package:imdumb_dependencies/imdumb_dependencies.dart';
import 'package:imdumb/domain/models/entities/cast.dart';
import 'package:imdumb/domain/models/entities/movie.dart';
import 'package:imdumb/presentation/providers/core_providers.dart';

final movieDetailProvider = FutureProvider.family<Movie, int>((ref, movieId) async {
  final usecase = ref.read(getMovieDetailProvider);
  final result = await usecase(movieId);
  return result.fold((failure) => throw failure.message, (movie) => movie);
});

final movieCreditsProvider = FutureProvider.family<List<Cast>, int>((ref, movieId) async {
  final usecase = ref.read(getMovieCreditsProvider);
  final result = await usecase(movieId);
  return result.fold((failure) => throw failure.message, (cast) => cast);
});
