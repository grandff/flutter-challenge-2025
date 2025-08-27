import 'package:flutter/material.dart';

class SettingsItemModel {
  final String id;
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDestructive;

  SettingsItemModel({
    required this.id,
    required this.title,
    required this.icon,
    this.onTap,
    this.isDestructive = false,
  });

  // Returns an empty instance
  SettingsItemModel.empty()
      : id = "",
        title = "",
        icon = Icons.settings,
        onTap = null,
        isDestructive = false;

  // Creates an instance from a JSON map
  SettingsItemModel.fromJson({required Map<String, dynamic> json})
      : id = json["id"] ?? "",
        title = json["title"] ?? "",
        icon =
            IconData(json["iconCodePoint"] ?? 0, fontFamily: 'MaterialIcons'),
        onTap = null,
        isDestructive = json["isDestructive"] ?? false;

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "iconCodePoint": icon.codePoint,
        "isDestructive": isDestructive,
      };
}




