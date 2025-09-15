import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings_item_model.dart';
import '../repos/settings_repo.dart';

final settingsRepoProvider = Provider<SettingsRepo>((ref) {
  return SettingsRepo();
});

final settingsViewModelProvider =
    StateNotifierProvider<SettingsViewModel, SettingsState>((ref) {
  final repo = ref.read(settingsRepoProvider);
  return SettingsViewModel(repo);
});

class SettingsState {
  final List<SettingsItemModel> settingsItems;
  final bool isLoggingOut;
  final String? error;

  SettingsState({
    this.settingsItems = const [],
    this.isLoggingOut = false,
    this.error,
  });

  SettingsState copyWith({
    List<SettingsItemModel>? settingsItems,
    bool? isLoggingOut,
    String? error,
  }) {
    return SettingsState(
      settingsItems: settingsItems ?? this.settingsItems,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      error: error ?? this.error,
    );
  }
}

class SettingsViewModel extends StateNotifier<SettingsState> {
  final SettingsRepo _repo;

  SettingsViewModel(this._repo) : super(SettingsState()) {
    loadSettingsItems();
  }

  void loadSettingsItems() {
    final items = _repo.getSettingsItems();
    state = state.copyWith(settingsItems: items);
  }

  Future<bool> logout() async {
    state = state.copyWith(isLoggingOut: true, error: null);

    try {
      final success = await _repo.logout();
      state = state.copyWith(isLoggingOut: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoggingOut: false,
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}


















