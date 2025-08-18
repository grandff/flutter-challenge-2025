class PomodoroModel {
  final int selectedMinutes;
  final int currentMinutes;
  final int currentSeconds;
  final bool isRunning;
  final bool isPaused;
  final bool isBreak;
  final int completedCycles;
  final int completedRounds;
  final int totalCycles;
  final int totalRounds;

  PomodoroModel({
    required this.selectedMinutes,
    required this.currentMinutes,
    required this.currentSeconds,
    required this.isRunning,
    required this.isPaused,
    required this.isBreak,
    required this.completedCycles,
    required this.completedRounds,
    required this.totalCycles,
    required this.totalRounds,
  });

  // Returns an empty instance
  PomodoroModel.empty()
      : selectedMinutes = 25,
        currentMinutes = 25,
        currentSeconds = 0,
        isRunning = false,
        isPaused = false,
        isBreak = false,
        completedCycles = 0,
        completedRounds = 0,
        totalCycles = 0,
        totalRounds = 0;

  // Creates an instance from a JSON map
  PomodoroModel.fromJson({required Map<String, dynamic> json})
      : selectedMinutes = json["selectedMinutes"] ?? 25,
        currentMinutes = json["currentMinutes"] ?? 25,
        currentSeconds = json["currentSeconds"] ?? 0,
        isRunning = json["isRunning"] ?? false,
        isPaused = json["isPaused"] ?? false,
        isBreak = json["isBreak"] ?? false,
        completedCycles = json["completedCycles"] ?? 0,
        completedRounds = json["completedRounds"] ?? 0,
        totalCycles = json["totalCycles"] ?? 0,
        totalRounds = json["totalRounds"] ?? 0;

  // Converts the instance to a JSON map
  Map<String, dynamic> toJson() => {
        "selectedMinutes": selectedMinutes,
        "currentMinutes": currentMinutes,
        "currentSeconds": currentSeconds,
        "isRunning": isRunning,
        "isPaused": isPaused,
        "isBreak": isBreak,
        "completedCycles": completedCycles,
        "completedRounds": completedRounds,
        "totalCycles": totalCycles,
        "totalRounds": totalRounds,
      };

  // Copy with method for immutable updates
  PomodoroModel copyWith({
    int? selectedMinutes,
    int? currentMinutes,
    int? currentSeconds,
    bool? isRunning,
    bool? isPaused,
    bool? isBreak,
    int? completedCycles,
    int? completedRounds,
    int? totalCycles,
    int? totalRounds,
  }) {
    return PomodoroModel(
      selectedMinutes: selectedMinutes ?? this.selectedMinutes,
      currentMinutes: currentMinutes ?? this.currentMinutes,
      currentSeconds: currentSeconds ?? this.currentSeconds,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      isBreak: isBreak ?? this.isBreak,
      completedCycles: completedCycles ?? this.completedCycles,
      completedRounds: completedRounds ?? this.completedRounds,
      totalCycles: totalCycles ?? this.totalCycles,
      totalRounds: totalRounds ?? this.totalRounds,
    );
  }

  // Get total seconds for timer
  int get totalSeconds => currentMinutes * 60 + currentSeconds;

  // Check if timer is finished
  bool get isFinished => totalSeconds <= 0;

  // Get formatted time string
  String get formattedTime {
    final minutes = currentMinutes.toString().padLeft(2, '0');
    final seconds = currentSeconds.toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
