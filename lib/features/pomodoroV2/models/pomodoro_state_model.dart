enum PomodoroStatus {
  stopped,
  running,
  paused,
}

class PomodoroStateModel {
  final int totalMinutes;
  final int remainingSeconds;
  final PomodoroStatus status;
  final double progress;

  PomodoroStateModel({
    required this.totalMinutes,
    required this.remainingSeconds,
    required this.status,
    required this.progress,
  });

  PomodoroStateModel.empty()
      : totalMinutes = 25,
        remainingSeconds = 25 * 60,
        status = PomodoroStatus.stopped,
        progress = 0.0;

  PomodoroStateModel.fromJson({required Map<String, dynamic> json})
      : totalMinutes = json["totalMinutes"] ?? 25,
        remainingSeconds = json["remainingSeconds"] ?? 25 * 60,
        status = PomodoroStatus.values[json["status"] ?? 0],
        progress = json["progress"]?.toDouble() ?? 0.0;

  Map<String, dynamic> toJson() => {
        "totalMinutes": totalMinutes,
        "remainingSeconds": remainingSeconds,
        "status": status.index,
        "progress": progress,
      };

  PomodoroStateModel copyWith({
    int? totalMinutes,
    int? remainingSeconds,
    PomodoroStatus? status,
    double? progress,
  }) {
    return PomodoroStateModel(
      totalMinutes: totalMinutes ?? this.totalMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
      progress: progress ?? this.progress,
    );
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}





