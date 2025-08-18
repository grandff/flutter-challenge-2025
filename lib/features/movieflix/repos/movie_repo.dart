import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/movie_model.dart';

class MovieRepo {
  static const String _base = 'https://movies-api.nomadcoders.workers.dev';

  Future<List<MovieModel>> fetchPopular() async {
    final uri = Uri.parse('$_base/popular');
    final res = await http.get(uri);
    if (res.statusCode != 200) return [];
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final results = (data['results'] as List? ?? []);
    return results
        .map((e) => MovieModel.fromJson(json: Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<MovieModel>> fetchNowPlaying() async {
    final uri = Uri.parse('$_base/now-playing');
    final res = await http.get(uri);
    if (res.statusCode != 200) return [];
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final results = (data['results'] as List? ?? []);
    return results
        .map((e) => MovieModel.fromJson(json: Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<MovieModel>> fetchComingSoon() async {
    final uri = Uri.parse('$_base/coming-soon');
    final res = await http.get(uri);
    if (res.statusCode != 200) return [];
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final results = (data['results'] as List? ?? []);
    return results
        .map((e) => MovieModel.fromJson(json: Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<MovieModel> fetchDetail(int id) async {
    final uri = Uri.parse('$_base/movie?id=$id');
    final res = await http.get(uri);
    if (res.statusCode != 200) return MovieModel.empty();
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return MovieModel.fromJson(json: data);
  }
}
