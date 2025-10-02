import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/flashcard_model.dart';

// 플래시 카드 상태 클래스
class FlashcardState {
  final List<FlashcardModel> flashcards;
  final int currentIndex;
  final bool isFlipped;
  final Color backgroundColor;
  final bool isLoading;

  FlashcardState({
    required this.flashcards,
    required this.currentIndex,
    required this.isFlipped,
    required this.backgroundColor,
    required this.isLoading,
  });

  FlashcardState copyWith({
    List<FlashcardModel>? flashcards,
    int? currentIndex,
    bool? isFlipped,
    Color? backgroundColor,
    bool? isLoading,
  }) {
    return FlashcardState(
      flashcards: flashcards ?? this.flashcards,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  // 진행률 계산 (0.0 ~ 1.0)
  double get progress {
    if (flashcards.isEmpty) return 0.0;
    return currentIndex / flashcards.length;
  }

  // 현재 카드 가져오기
  FlashcardModel? get currentCard {
    if (flashcards.isEmpty || currentIndex >= flashcards.length) return null;
    return flashcards[currentIndex];
  }

  // 다음 카드로 이동 가능한지 확인
  bool get hasNextCard {
    return currentIndex < flashcards.length - 1;
  }

  // 모든 카드 완료 여부
  bool get isCompleted {
    return flashcards.isNotEmpty && currentIndex >= flashcards.length;
  }
}

// 플래시 카드 뷰 모델
class FlashcardViewModel extends StateNotifier<FlashcardState> {
  FlashcardViewModel() : super(_initialState) {
    _loadFlashcards();
  }

  static final FlashcardState _initialState = FlashcardState(
    flashcards: [],
    currentIndex: 0,
    isFlipped: false,
    backgroundColor: Colors.white,
    isLoading: true,
  );

  // 샘플 플래시 카드 데이터 로드
  void _loadFlashcards() {
    state = state.copyWith(isLoading: true);

    // 샘플 데이터 생성
    final sampleFlashcards = [
      FlashcardModel(
        id: "1",
        question: "Flutter는 어떤 언어로 개발되었나요?",
        answer: "Dart 언어로 개발되었습니다.",
      ),
      FlashcardModel(
        id: "2",
        question: "Riverpod의 주요 특징은 무엇인가요?",
        answer: "상태 관리, 의존성 주입, 캐싱을 제공합니다.",
      ),
      FlashcardModel(
        id: "3",
        question: "Widget의 두 가지 주요 타입은?",
        answer: "StatelessWidget과 StatefulWidget입니다.",
      ),
      FlashcardModel(
        id: "4",
        question: "MaterialApp의 주요 역할은?",
        answer: "앱의 테마, 라우팅, 로케일 등을 설정합니다.",
      ),
      FlashcardModel(
        id: "5",
        question: "ProviderScope는 언제 사용하나요?",
        answer: "Riverpod 상태 관리를 위해 앱 최상위에 배치합니다.",
      ),
    ];

    state = state.copyWith(
      flashcards: sampleFlashcards,
      isLoading: false,
    );
  }

  // 카드 뒤집기
  void flipCard() {
    if (state.currentCard == null) return;

    state = state.copyWith(isFlipped: !state.isFlipped);
  }

  // 다음 카드로 이동
  void nextCard() {
    if (!state.hasNextCard) return;

    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      isFlipped: false,
      backgroundColor: Colors.white,
    );
  }

  // 카드 드래그 처리
  void onCardDragged(double deltaX) {
    if (state.currentCard == null) return;

    Color newBackgroundColor = Colors.white;

    // 화면 너비의 1/4 이상 드래그해야 색상 변경 (대략 100px)
    if (deltaX < -100) {
      // 왼쪽으로 드래그 - 빨간색
      newBackgroundColor = Colors.red.shade100;
    } else if (deltaX > 100) {
      // 오른쪽으로 드래그 - 녹색
      newBackgroundColor = Colors.green.shade100;
    }

    state = state.copyWith(backgroundColor: newBackgroundColor);
  }

  // 카드 드롭 처리
  void onCardDropped(double deltaX) {
    if (state.currentCard == null) return;

    // 화면 너비의 1/2 이상 드래그해야 다음 카드로 이동 (대략 200px)
    if (deltaX < -200 || deltaX > 200) {
      // 카드가 충분히 드래그되었다면 다음 카드로 이동
      nextCard();
    } else {
      // 드래그되지 않았다면 배경색 초기화
      state = state.copyWith(backgroundColor: Colors.white);
    }
  }

  // 학습 재시작
  void restart() {
    state = state.copyWith(
      currentIndex: 0,
      isFlipped: false,
      backgroundColor: Colors.white,
    );
  }

  // 새로운 플래시 카드 추가
  void addFlashcard(String question, String answer) {
    final newCard = FlashcardModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      question: question,
      answer: answer,
    );

    state = state.copyWith(
      flashcards: [...state.flashcards, newCard],
    );
  }
}

// Provider 정의
final flashcardProvider =
    StateNotifierProvider<FlashcardViewModel, FlashcardState>((ref) {
  return FlashcardViewModel();
});
