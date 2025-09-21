import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/animation_state_model.dart';

class AnimationViewModel extends StateNotifier<AnimationStateModel> {
  AnimationViewModel() : super(AnimationStateModel.empty());

  static final provider = StateNotifierProvider<AnimationViewModel, AnimationStateModel>(
    (ref) => AnimationViewModel(),
  );

  // 크기 애니메이션 토글
  void toggleSizeAnimation() {
    state = state.copyWith(
      size: state.size == 100.0 ? 200.0 : 100.0,
      isAnimating: !state.isAnimating,
    );
  }

  // 투명도 애니메이션 토글
  void toggleOpacityAnimation() {
    state = state.copyWith(
      opacity: state.opacity == 1.0 ? 0.3 : 1.0,
      isAnimating: !state.isAnimating,
    );
  }

  // 회전 애니메이션 토글
  void toggleRotationAnimation() {
    state = state.copyWith(
      rotation: state.rotation == 0.0 ? 360.0 : 0.0,
      isAnimating: !state.isAnimating,
    );
  }

  // 스케일 애니메이션 토글
  void toggleScaleAnimation() {
    state = state.copyWith(
      scale: state.scale == 1.0 ? 1.5 : 1.0,
      isAnimating: !state.isAnimating,
    );
  }

  // 색상 변경
  void changeColor() {
    state = state.copyWith(
      colorIndex: (state.colorIndex + 1) % 6,
      isAnimating: !state.isAnimating,
    );
  }

  // 모든 애니메이션 리셋
  void resetAnimations() {
    state = AnimationStateModel.empty();
  }

  // 복합 애니메이션 (모든 애니메이션을 동시에)
  void toggleComplexAnimation() {
    state = state.copyWith(
      size: state.size == 100.0 ? 200.0 : 100.0,
      opacity: state.opacity == 1.0 ? 0.5 : 1.0,
      rotation: state.rotation == 0.0 ? 180.0 : 0.0,
      scale: state.scale == 1.0 ? 1.2 : 1.0,
      colorIndex: (state.colorIndex + 1) % 6,
      isAnimating: !state.isAnimating,
    );
  }
}

