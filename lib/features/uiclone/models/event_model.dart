class EventModel {
  final String id;
  final String title;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final List<String> participants;
  final String color;

  EventModel({
    required this.id,
    required this.title,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.participants,
    required this.color,
  });

  // Returns an empty instance
  EventModel.empty()
      : id = "",
        title = "",
        startHour = 0,
        startMinute = 0,
        endHour = 0,
        endMinute = 0,
        participants = const [],
        color = "";

  // Creates an instance from a JSON map
  EventModel.fromJson({required Map<String, dynamic> json})
      : id = json["id"] ?? "",
        title = json["title"] ?? "",
        startHour = json["startHour"] ?? 0,
        startMinute = json["startMinute"] ?? 0,
        endHour = json["endHour"] ?? 0,
        endMinute = json["endMinute"] ?? 0,
        participants = List<String>.from(json["participants"] ?? []),
        color = json["color"] ?? "";

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "startHour": startHour,
        "startMinute": startMinute,
        "endHour": endHour,
        "endMinute": endMinute,
        "participants": participants,
        "color": color,
      };
}
