class MovieModel {
  final int id;
  final String title;
  final String posterUrl;
  final double voteAverage;
  final String overview;
  final List<String> genres;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.voteAverage,
    required this.overview,
    required this.genres,
  });

  // Returns an empty instance
  MovieModel.empty()
      : id = 0,
        title = "",
        posterUrl = "",
        voteAverage = 0.0,
        overview = "",
        genres = const [];

  // Creates an instance from a JSON map
  MovieModel.fromJson({required Map<String, dynamic> json})
      : id =
            json["id"] is int ? json["id"] : int.tryParse("${json["id"]}") ?? 0,
        title = (json["title"] ?? json["name"] ?? "") as String,
        posterUrl = _resolvePosterUrl(json["poster_path"] ?? json["poster"]),
        voteAverage = _parseDouble(json["vote_average"] ?? json["rating"] ?? 0),
        overview = (json["overview"] ?? "") as String,
        genres = _parseGenres(json["genres"]);

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "posterUrl": posterUrl,
        "voteAverage": voteAverage,
        "overview": overview,
        "genres": genres,
      };

  static String _resolvePosterUrl(dynamic raw) {
    final value = (raw ?? "") as String;
    if (value.isEmpty) return "";
    if (value.startsWith("http")) return value;
    // Fallback to TMDB CDN path if only path is provided
    return "https://image.tmdb.org/t/p/w500$value";
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse("$value") ?? 0.0;
  }

  static List<String> _parseGenres(dynamic raw) {
    if (raw == null) return const [];
    if (raw is List) {
      if (raw.isEmpty) return const [];
      final first = raw.first;
      if (first is String) {
        return List<String>.from(raw);
      }
      if (first is Map<String, dynamic>) {
        return raw
            .map((e) => (e["name"] ?? "").toString())
            .where((e) => e.isNotEmpty)
            .cast<String>()
            .toList();
      }
    }
    return const [];
  }
}
