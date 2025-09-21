class AnimationStateModel {
  final double size;
  final double opacity;
  final double rotation;
  final double scale;
  final bool isAnimating;
  final int colorIndex;

  AnimationStateModel({
    required this.size,
    required this.opacity,
    required this.rotation,
    required this.scale,
    required this.isAnimating,
    required this.colorIndex,
  });

  AnimationStateModel.empty()
      : size = 100.0,
        opacity = 1.0,
        rotation = 0.0,
        scale = 1.0,
        isAnimating = false,
        colorIndex = 0;

  AnimationStateModel.fromJson({required Map<String, dynamic> json})
      : size = json["size"]?.toDouble() ?? 100.0,
        opacity = json["opacity"]?.toDouble() ?? 1.0,
        rotation = json["rotation"]?.toDouble() ?? 0.0,
        scale = json["scale"]?.toDouble() ?? 1.0,
        isAnimating = json["isAnimating"] ?? false,
        colorIndex = json["colorIndex"] ?? 0;

  Map<String, dynamic> toJson() => {
        "size": size,
        "opacity": opacity,
        "rotation": rotation,
        "scale": scale,
        "isAnimating": isAnimating,
        "colorIndex": colorIndex,
      };

  AnimationStateModel copyWith({
    double? size,
    double? opacity,
    double? rotation,
    double? scale,
    bool? isAnimating,
    int? colorIndex,
  }) {
    return AnimationStateModel(
      size: size ?? this.size,
      opacity: opacity ?? this.opacity,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      isAnimating: isAnimating ?? this.isAnimating,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }
}

