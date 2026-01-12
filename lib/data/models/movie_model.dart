import 'package:imdumb/domain/models/entities/movie.dart';

class MovieModel extends Movie {
  MovieModel({
    required super.id,
    required super.title,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.overview,
    required super.releaseDate,
    super.runtime,
    super.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '', // Sometimes null
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      overview: json['overview'] ?? '',
      releaseDate: json['release_date'] ?? '',
      runtime: json['runtime'],
      genres: json['genres'] != null ? (json['genres'] as List).map((e) => e['name'] as String).toList() : null,
    );
  }
}
