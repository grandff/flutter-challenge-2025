class UserModel {
  final String id;
  final String email;
  final String? phone;
  final String name;
  final String? dateOfBirth;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.phone,
    required this.name,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
  });

  UserModel.empty()
      : id = "",
        email = "",
        phone = null,
        name = "",
        dateOfBirth = null,
        createdAt = null,
        updatedAt = null;

  UserModel.fromJson({required Map<String, dynamic> json})
      : id = json["id"] ?? "",
        email = json["email"] ?? "",
        phone = json["phone"],
        name = json["name"] ?? "",
        dateOfBirth = json["date_of_birth"],
        createdAt = json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        updatedAt = json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : null;

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "phone": phone,
        "name": name,
        "date_of_birth": dateOfBirth,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}


