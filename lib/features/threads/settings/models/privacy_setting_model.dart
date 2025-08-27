import 'package:flutter/material.dart';

class PrivacySettingModel {
  final String id;
  final String title;
  final IconData icon;
  final PrivacySettingType type;
  final bool isEnabled;
  final String? value;
  final String? description;
  final bool isExternalLink;

  PrivacySettingModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.type,
    this.isEnabled = false,
    this.value,
    this.description,
    this.isExternalLink = false,
  });

  // Returns an empty instance
  PrivacySettingModel.empty()
      : id = "",
        title = "",
        icon = Icons.settings,
        type = PrivacySettingType.toggle,
        isEnabled = false,
        value = null,
        description = null,
        isExternalLink = false;

  // Creates an instance from a JSON map
  PrivacySettingModel.fromJson({required Map<String, dynamic> json})
      : id = json["id"] ?? "",
        title = json["title"] ?? "",
        icon =
            IconData(json["iconCodePoint"] ?? 0, fontFamily: 'MaterialIcons'),
        type = PrivacySettingType.values.firstWhere(
          (e) =>
              e.toString() == 'PrivacySettingType.${json["type"] ?? "toggle"}',
          orElse: () => PrivacySettingType.toggle,
        ),
        isEnabled = json["isEnabled"] ?? false,
        value = json["value"],
        description = json["description"],
        isExternalLink = json["isExternalLink"] ?? false;

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "iconCodePoint": icon.codePoint,
        "type": type.toString().split('.').last,
        "isEnabled": isEnabled,
        "value": value,
        "description": description,
        "isExternalLink": isExternalLink,
      };

  // Copy with method for updating values
  PrivacySettingModel copyWith({
    String? id,
    String? title,
    IconData? icon,
    PrivacySettingType? type,
    bool? isEnabled,
    String? value,
    String? description,
    bool? isExternalLink,
  }) {
    return PrivacySettingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
      value: value ?? this.value,
      description: description ?? this.description,
      isExternalLink: isExternalLink ?? this.isExternalLink,
    );
  }
}

enum PrivacySettingType {
  toggle, // Switch (e.g., Private profile)
  select, // Dropdown/Selection (e.g., Mentions)
  navigation, // Navigation to sub-screen (e.g., Muted, Hidden Words)
  external, // External link (e.g., Blocked profiles, Hide likes)
}




