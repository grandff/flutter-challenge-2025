class InitialModel {
  final String id;
  final String name;

  InitialModel({
    required this.id,
    required this.name,
  });

  InitialModel.empty()
      : id = '',
        name = '';

  InitialModel.fromJson({required Map<String, dynamic> json})
      : id = json['id'] ?? '',
        name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}




