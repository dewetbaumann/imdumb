class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String overview;
  final String releaseDate;
  // Detail fields
  final int? runtime;
  final List<String>? genres;

  const Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.overview,
    required this.releaseDate,
    this.runtime,
    this.genres,
  });
}
