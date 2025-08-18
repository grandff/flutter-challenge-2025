class SearchModel {
  final String id;
  final String query;
  final List<String> results;
  final DateTime searchTime;

  SearchModel({
    required this.id,
    required this.query,
    required this.results,
    required this.searchTime,
  });

  // Returns an empty instance
  SearchModel.empty()
      : id = "",
        query = "",
        results = [],
        searchTime = DateTime.now();

  // Creates an instance from a JSON map
  SearchModel.fromJson({required Map<String, dynamic> json})
      : id = json["id"] ?? "",
        query = json["query"] ?? "",
        results = List<String>.from(json["results"] ?? []),
        searchTime = DateTime.parse(
            json["searchTime"] ?? DateTime.now().toIso8601String());

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => {
        "id": id,
        "query": query,
        "results": results,
        "searchTime": searchTime.toIso8601String(),
      };
}
