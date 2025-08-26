import 'package:flutter/material.dart';
import '../models/settings_item_model.dart';

class SettingsRepo {
  // Get settings items list
  List<SettingsItemModel> getSettingsItems() {
    return [
      SettingsItemModel(
        id: "follow_invite",
        title: "Follow and invite friends",
        icon: Icons.person_add,
        onTap: () {
          // TODO: Navigate to follow and invite friends screen
        },
      ),
      SettingsItemModel(
        id: "notifications",
        title: "Notifications",
        icon: Icons.notifications,
        onTap: () {
          // TODO: Navigate to notifications settings screen
        },
      ),
      SettingsItemModel(
        id: "privacy",
        title: "Privacy",
        icon: Icons.lock,
        onTap: () {
          // Navigate to privacy settings screen
        },
      ),
      SettingsItemModel(
        id: "account",
        title: "Account",
        icon: Icons.account_circle,
        onTap: () {
          // TODO: Navigate to account settings screen
        },
      ),
      SettingsItemModel(
        id: "help",
        title: "Help",
        icon: Icons.help,
        onTap: () {
          // TODO: Navigate to help screen
        },
      ),
      SettingsItemModel(
        id: "about",
        title: "About",
        icon: Icons.info,
        onTap: () {
          // TODO: Navigate to about screen
        },
      ),
    ];
  }

  // Logout user
  Future<bool> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    // TODO: Implement actual logout logic
    // For now, just return success
    return true;
  }
}
