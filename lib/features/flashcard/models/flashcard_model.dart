class FlashcardModel {
  final String id;
  final String question;
  final String answer;
  final bool isFlipped;

  FlashcardModel({
    required this.id,
    required this.question,
    required this.answer,
    this.isFlipped = false,
  });

  // 빈 인스턴스 반환
  FlashcardModel.empty()
      : id = "",
        question = "",
        answer = "",
        isFlipped = false;

  // JSON에서 인스턴스 생성
  FlashcardModel.fromJson({required Map<String, dynamic> json})
      : id = json["id"] ?? "",
        question = json["question"] ?? "",
        answer = json["answer"] ?? "",
        isFlipped = json["isFlipped"] ?? false;

  // 인스턴스를 JSON으로 변환
  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "isFlipped": isFlipped,
      };

  // 카드 뒤집기 상태 복사
  FlashcardModel copyWith({
    String? id,
    String? question,
    String? answer,
    bool? isFlipped,
  }) {
    return FlashcardModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isFlipped: isFlipped ?? this.isFlipped,
    );
  }

  @override
  String toString() {
    return 'FlashcardModel(id: $id, question: $question, answer: $answer, isFlipped: $isFlipped)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlashcardModel &&
        other.id == id &&
        other.question == question &&
        other.answer == answer &&
        other.isFlipped == isFlipped;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        question.hashCode ^
        answer.hashCode ^
        isFlipped.hashCode;
  }
}



