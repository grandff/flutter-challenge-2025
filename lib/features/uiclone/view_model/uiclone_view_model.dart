import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_model.dart';
import '../repos/event_repo.dart';

class UiCloneViewModel extends StateNotifier<UiCloneState> {
  final EventRepo _eventRepo;

  UiCloneViewModel(this._eventRepo) : super(UiCloneState.initial()) {
    loadEvents();
  }

  void loadEvents() {
    final events = _eventRepo.getEvents();
    final dates = _eventRepo.getDates();

    state = state.copyWith(
      events: events,
      dates: dates,
      isLoading: false,
    );
  }

  void selectDate(int index) {
    state = state.copyWith(selectedDateIndex: index);
  }
}

class UiCloneState {
  final List<EventModel> events;
  final List<String> dates;
  final int selectedDateIndex;
  final bool isLoading;

  UiCloneState({
    required this.events,
    required this.dates,
    required this.selectedDateIndex,
    required this.isLoading,
  });

  factory UiCloneState.initial() {
    return UiCloneState(
      events: [],
      dates: [],
      selectedDateIndex: 0,
      isLoading: true,
    );
  }

  UiCloneState copyWith({
    List<EventModel>? events,
    List<String>? dates,
    int? selectedDateIndex,
    bool? isLoading,
  }) {
    return UiCloneState(
      events: events ?? this.events,
      dates: dates ?? this.dates,
      selectedDateIndex: selectedDateIndex ?? this.selectedDateIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Providers
final eventRepoProvider = Provider<EventRepo>((ref) => EventRepo());

final uiCloneViewModelProvider =
    StateNotifierProvider<UiCloneViewModel, UiCloneState>(
  (ref) => UiCloneViewModel(ref.watch(eventRepoProvider)),
);
