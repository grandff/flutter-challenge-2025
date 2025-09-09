import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/privacy_setting_model.dart';
import '../repos/privacy_repo.dart';

final privacyRepoProvider = Provider<PrivacyRepo>((ref) {
  return PrivacyRepo();
});

final privacyViewModelProvider =
    StateNotifierProvider<PrivacyViewModel, PrivacyState>((ref) {
  final repo = ref.read(privacyRepoProvider);
  return PrivacyViewModel(repo);
});

class PrivacyState {
  final List<PrivacySettingModel> privacySettings;
  final bool isLoading;
  final String? error;
  final Map<String, String> sectionDescriptions;

  PrivacyState({
    this.privacySettings = const [],
    this.isLoading = false,
    this.error,
    this.sectionDescriptions = const {},
  });

  PrivacyState copyWith({
    List<PrivacySettingModel>? privacySettings,
    bool? isLoading,
    String? error,
    Map<String, String>? sectionDescriptions,
  }) {
    return PrivacyState(
      privacySettings: privacySettings ?? this.privacySettings,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      sectionDescriptions: sectionDescriptions ?? this.sectionDescriptions,
    );
  }
}

class PrivacyViewModel extends StateNotifier<PrivacyState> {
  final PrivacyRepo _repo;

  PrivacyViewModel(this._repo) : super(PrivacyState()) {
    loadPrivacySettings();
  }

  void loadPrivacySettings() {
    final settings = _repo.getPrivacySettings();
    final descriptions = _repo.getSectionDescriptions();
    state = state.copyWith(
      privacySettings: settings,
      sectionDescriptions: descriptions,
    );
  }

  Future<void> updatePrivacySetting(String id, dynamic value) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final success = await _repo.updatePrivacySetting(id, value);
      if (success) {
        // Update local state
        final updatedSettings = state.privacySettings.map((setting) {
          if (setting.id == id) {
            if (setting.type == PrivacySettingType.toggle) {
              return setting.copyWith(isEnabled: value as bool);
            } else if (setting.type == PrivacySettingType.select) {
              return setting.copyWith(value: value as String);
            }
          }
          return setting;
        }).toList();

        state = state.copyWith(
          privacySettings: updatedSettings,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: "Failed to update setting",
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  // Get settings by section
  List<PrivacySettingModel> getGeneralPrivacySettings() {
    return state.privacySettings.take(5).toList();
  }

  List<PrivacySettingModel> getOtherPrivacySettings() {
    return state.privacySettings.skip(5).toList();
  }
}














