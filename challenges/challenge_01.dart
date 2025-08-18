// Challenge 01: Dictionary 클래스 구현
// 요구사항: class, typedefs, List, Map 사용

// typedefs 정의
typedef Word = String;
typedef Definition = String;
typedef DictionaryEntry = Map<String, String>;
typedef WordList = List<String>;
typedef EntryList = List<DictionaryEntry>;

/// 사전을 관리하는 Dictionary 클래스
class Dictionary {
  // 내부 저장소: Map을 사용하여 단어와 정의를 저장
  final Map<Word, Definition> _words = <Word, Definition>{};

  /// 단어를 추가하는 메서드
  void add(Word term, Definition definition) {
    if (_words.containsKey(term)) {
      print('경고: "$term"은 이미 존재하는 단어입니다.');
      return;
    }
    _words[term] = definition;
    print('단어 "$term"이 추가되었습니다.');
  }

  /// 단어의 정의를 리턴하는 메서드
  Definition? get(Word term) {
    if (!_words.containsKey(term)) {
      print('오류: "$term"을 찾을 수 없습니다.');
      return null;
    }
    return _words[term];
  }

  /// 단어를 삭제하는 메서드
  bool delete(Word term) {
    if (!_words.containsKey(term)) {
      print('오류: "$term"을 찾을 수 없습니다.');
      return false;
    }
    _words.remove(term);
    print('단어 "$term"이 삭제되었습니다.');
    return true;
  }

  /// 단어를 업데이트하는 메서드
  bool update(Word term, Definition newDefinition) {
    if (!_words.containsKey(term)) {
      print('오류: "$term"을 찾을 수 없습니다.');
      return false;
    }
    _words[term] = newDefinition;
    print('단어 "$term"의 정의가 업데이트되었습니다.');
    return true;
  }

  /// 사전의 모든 단어를 보여주는 메서드
  void showAll() {
    if (_words.isEmpty) {
      print('사전이 비어있습니다.');
      return;
    }

    print('\n=== 사전 전체 목록 ===');
    _words.forEach((term, definition) {
      print('$term: $definition');
    });
    print('=====================\n');
  }

  /// 사전 단어들의 총 개수를 리턴하는 메서드
  int count() {
    return _words.length;
  }

  /// 단어를 업데이트하거나 존재하지 않으면 추가하는 메서드 (upsert)
  void upsert(Word term, Definition definition) {
    if (_words.containsKey(term)) {
      _words[term] = definition;
      print('단어 "$term"이 업데이트되었습니다.');
    } else {
      _words[term] = definition;
      print('단어 "$term"이 추가되었습니다.');
    }
  }

  /// 해당 단어가 사전에 존재하는지 여부를 확인하는 메서드
  bool exists(Word term) {
    return _words.containsKey(term);
  }

  /// 여러 단어를 한번에 추가하는 메서드
  void bulkAdd(EntryList entries) {
    if (entries.isEmpty) {
      print('추가할 단어가 없습니다.');
      return;
    }

    int addedCount = 0;
    int skippedCount = 0;

    for (DictionaryEntry entry in entries) {
      // entry 유효성 검사
      if (!entry.containsKey('term') || !entry.containsKey('definition')) {
        print('오류: 잘못된 형식의 항목이 건너뛰어졌습니다. $entry');
        skippedCount++;
        continue;
      }

      Word term = entry['term']!;
      Definition definition = entry['definition']!;

      if (_words.containsKey(term)) {
        print('경고: "$term"은 이미 존재하여 건너뛰었습니다.');
        skippedCount++;
      } else {
        _words[term] = definition;
        addedCount++;
      }
    }

    print('대량 추가 완료: $addedCount개 추가, $skippedCount개 건너뛰었습니다.');
  }

  /// 여러 단어를 한번에 삭제하는 메서드
  void bulkDelete(WordList terms) {
    if (terms.isEmpty) {
      print('삭제할 단어가 없습니다.');
      return;
    }

    int deletedCount = 0;
    int notFoundCount = 0;

    for (Word term in terms) {
      if (_words.containsKey(term)) {
        _words.remove(term);
        deletedCount++;
      } else {
        print('경고: "$term"을 찾을 수 없어 건너뛰었습니다.');
        notFoundCount++;
      }
    }

    print('대량 삭제 완료: $deletedCount개 삭제, $notFoundCount개를 찾을 수 없었습니다.');
  }

  /// 사전의 모든 단어 목록을 리턴하는 보조 메서드
  WordList getAllTerms() {
    return _words.keys.toList();
  }

  /// 사전이 비어있는지 확인하는 보조 메서드
  bool isEmpty() {
    return _words.isEmpty;
  }

  /// 사전을 초기화하는 메서드
  void clear() {
    _words.clear();
    print('사전이 초기화되었습니다.');
  }
}

/// Dictionary 클래스를 테스트하는 함수
void main() {
  print('=== Dictionary 클래스 테스트 시작 ===\n');

  // Dictionary 인스턴스 생성
  Dictionary dictionary = Dictionary();

  // 1. 개별 단어 추가 테스트
  print('1. 개별 단어 추가 테스트');
  dictionary.add('사과', '빨간 과일');
  dictionary.add('바나나', '노란 과일');
  dictionary.add('사과', '중복 추가 테스트'); // 중복 추가 시도

  // 2. 단어 조회 테스트
  print('\n2. 단어 조회 테스트');
  print('사과 정의: ${dictionary.get('사과')}');
  print('포도 정의: ${dictionary.get('포도')}'); // 존재하지 않는 단어

  // 3. 단어 개수 확인
  print('\n3. 단어 개수: ${dictionary.count()}개');

  // 4. 존재 여부 확인
  print('\n4. 존재 여부 확인');
  print('사과 존재 여부: ${dictionary.exists('사과')}');
  print('포도 존재 여부: ${dictionary.exists('포도')}');

  // 5. 전체 사전 보기
  print('\n5. 전체 사전 보기');
  dictionary.showAll();

  // 6. 단어 업데이트 테스트
  print('6. 단어 업데이트 테스트');
  dictionary.update('사과', '달콤한 빨간 과일');
  dictionary.update('포도', '존재하지 않는 단어 업데이트 시도');

  // 7. upsert 테스트
  print('\n7. upsert 테스트');
  dictionary.upsert('바나나', '달콤한 노란 과일'); // 기존 단어 업데이트
  dictionary.upsert('포도', '보라색 과일'); // 새 단어 추가

  // 8. 대량 추가 테스트
  print('\n8. 대량 추가 테스트');
  EntryList bulkEntries = [
    {'term': '김치', 'definition': '대박이네~'},
    {'term': '아파트', 'definition': '비싸네~'},
    {'term': '자동차', 'definition': '편리한 교통수단'},
    {'term': '사과', 'definition': '중복 단어 테스트'}
  ];
  dictionary.bulkAdd(bulkEntries);

  // 9. 현재 상태 확인
  print('\n9. 현재 사전 상태');
  dictionary.showAll();
  print('총 단어 개수: ${dictionary.count()}개');

  // 10. 단어 삭제 테스트
  print('\n10. 단어 삭제 테스트');
  dictionary.delete('바나나');
  dictionary.delete('존재하지않는단어');

  // 11. 대량 삭제 테스트
  print('\n11. 대량 삭제 테스트');
  WordList deleteTerms = ['김치', '아파트', '존재하지않는단어'];
  dictionary.bulkDelete(deleteTerms);

  // 12. 최종 상태
  print('\n12. 최종 사전 상태');
  dictionary.showAll();
  print('최종 단어 개수: ${dictionary.count()}개');

  print('\n=== Dictionary 클래스 테스트 완료 ===');
}
