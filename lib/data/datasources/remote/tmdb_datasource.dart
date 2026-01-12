import 'package:imdumb/core/app/app_url.dart';
import 'package:imdumb/data/repositories/external/http_repository.dart';
import 'package:imdumb/data/models/cast_model.dart';
import 'package:imdumb/data/models/genre_model.dart';
import 'package:imdumb/data/models/movie_model.dart';

abstract class TmdbDataSource {
  Future<List<GenreModel>> getGenres();
  Future<List<MovieModel>> getMoviesByGenre(int genreId);
  Future<MovieModel> getMovieDetail(int movieId);
  Future<List<CastModel>> getMovieCredits(int movieId);
}

class TmdbDataSourceImpl implements TmdbDataSource {
  final IHttp _http;

  TmdbDataSourceImpl(this._http);

  @override
  Future<List<GenreModel>> getGenres() async {
    final response = await _http.get('${AppUrl.baseUrl}/genre/movie/list');
    final List list = response.data['genres'];
    return list.map((e) => GenreModel.fromJson(e)).toList();
  }

  @override
  Future<List<MovieModel>> getMoviesByGenre(int genreId) async {
    final response = await _http.get('${AppUrl.baseUrl}/discover/movie', params: {'with_genres': genreId});
    final List list = response.data['results'];
    return list.map((e) => MovieModel.fromJson(e)).toList();
  }

  @override
  Future<MovieModel> getMovieDetail(int movieId) async {
    final response = await _http.get('${AppUrl.baseUrl}/movie/$movieId');
    return MovieModel.fromJson(response.data);
  }

  @override
  Future<List<CastModel>> getMovieCredits(int movieId) async {
    final response = await _http.get('${AppUrl.baseUrl}/movie/$movieId/credits');
    final List list = response.data['cast'];
    return list.map((e) => CastModel.fromJson(e)).toList();
  }
}
