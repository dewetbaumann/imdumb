import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imdumb/domain/models/entities/genre.dart';
import 'package:imdumb/domain/models/entities/movie.dart';
import 'package:imdumb/presentation/providers/core_providers.dart';

final genresProvider = FutureProvider<List<Genre>>((ref) async {
  final usecase = ref.read(getGenresProvider);
  final result = await usecase();
  return result.fold((failure) => throw failure.message, (genres) => genres);
});

final moviesByGenreProvider = FutureProvider.family<List<Movie>, int>((ref, genreId) async {
  final usecase = ref.read(getMoviesByGenreProvider);
  final result = await usecase(genreId);
  return result.fold((failure) => throw failure.message, (movies) => movies);
});
