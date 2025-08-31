import 'package:flutter/material.dart';
import '../models/privacy_setting_model.dart';

class PrivacyRepo {
  // Get privacy settings list
  List<PrivacySettingModel> getPrivacySettings() {
    return [
      // General Privacy Settings
      PrivacySettingModel(
        id: "private_profile",
        title: "Private profile",
        icon: Icons.lock,
        type: PrivacySettingType.toggle,
        isEnabled: true,
      ),
      PrivacySettingModel(
        id: "mentions",
        title: "Mentions",
        icon: Icons.alternate_email,
        type: PrivacySettingType.select,
        value: "Everyone",
      ),
      PrivacySettingModel(
        id: "muted",
        title: "Muted",
        icon: Icons.notifications_off,
        type: PrivacySettingType.navigation,
      ),
      PrivacySettingModel(
        id: "hidden_words",
        title: "Hidden Words",
        icon: Icons.chat_bubble_outline,
        type: PrivacySettingType.navigation,
      ),
      PrivacySettingModel(
        id: "profiles_you_follow",
        title: "Profiles you follow",
        icon: Icons.people,
        type: PrivacySettingType.navigation,
      ),
      // Other Privacy Settings
      PrivacySettingModel(
        id: "blocked_profiles",
        title: "Blocked profiles",
        icon: Icons.block,
        type: PrivacySettingType.external,
        isExternalLink: true,
      ),
      PrivacySettingModel(
        id: "hide_likes",
        title: "Hide likes",
        icon: Icons.favorite_border,
        type: PrivacySettingType.external,
        isExternalLink: true,
      ),
    ];
  }

  // Update privacy setting
  Future<bool> updatePrivacySetting(String id, dynamic value) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Implement actual API call to update privacy setting
    // For now, just return success
    return true;
  }

  // Get section descriptions
  Map<String, String> getSectionDescriptions() {
    return {
      "other_privacy":
          "Some settings, like restrict, apply to both Threads and Instagram and can be managed on Instagram.",
    };
  }
}








