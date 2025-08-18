class Vars {
  // static var that email or password constants
  static const String email = "Email";
  static const String password = "Password";
  static const String rePassword = "RePassword";
  static const String teamName = "TeamName";
  static const String teamDescription = "TeamDescription";
  static const String teamPassword = "TeamPassword";
  static const String gitHub = "Github";
  static const String kakao = "Kakao";

  static const int memberCountException = -1;

  static const String red = "RED";
  static const String green = "GREEN";
  static const String blue = "BLUE";
  static const String yellow = "YELLOW";
  static const String purple = "PURPLE";
  static const String orange = "ORANGE";
  static const String black = "BLACK";
  static const List<String> categoryColorList = [
    red,
    green,
    blue,
    yellow,
    purple,
    orange,
    black,
  ];

  static const int maxPageCount = 10;
  static const int maxPublicTeamCreateCount = 1;
  static const int maxPrivateTeamCreateCount = 2;

  static const String providerEmail = "email";
  static const String providerGoogle = "google";
  static const String providerApple = "apple";
  static const String providerGithub = "github";
  static const String providerKakao = "kakao";
  static const String providerUnknown = "unknown";

  static const String todoAlarmUnset = "취소";
  static const String todoAlarm10Min = "10분 후";
  static const String todoAlarm30Min = "30분 후";
  static const String todoAlarm60Min = "1시간 후";
  static const String todoAlarm1Day = "1일 후";
  static const String todoAlarm1Week = "1주일 후";

  static const String todoRoutineDay = "매일";
  static const String todoRoutineWeek = "매주";
  static const String todoRoutineMonth = "매월";
  static const String todoRoutineDayStr = "Day";
  static const String todoRoutineWeekStr = "Week";
  static const String todoRoutineMonthStr = "Month";

  // TODO 의미 있는걸로 바꿔야함.. 지금은 임의로 했음..
  static const String todoRoutineActivity = "activity";
  static const String todoRoutineBasketball = "basketball";
  static const String todoRoutineCafe = "cafe";
  static const String todoRoutineDashboard = "dashboard";
  static const String todoRoutineEarth = "earth";
  static const String todoRoutineFinance = "finance";

  static const String todoInsertMode = "INSERT";
  static const String todoUpdateMode = "UPDATE";

  static const String todoCategoryName = "todoCategoryName";

  // 구분선
  static const int commonDivider = 1;
  static const int heavyThickDivider = 2;
  static const int smallThickDivider = 3;
  static const int mediumThickDivider = 4;
  static const int thinDivider = 5;
  static const int veryHeavyThickDivider = 6;
  static const int mainDateDivider = 7;
  static const int historyDivider = 8;

  // toast 종류
  static const String successToast = "SUCCESS";
  static const String infoToast = "INFO";
  static const String warnToast = "WARN";
  static const String errorToast = "ERROR";

  // 팀 인원 설정
  static const double defaultMemberCount = 10.0;
  static const double minMemberCount = 5.0;
  static const double maxMemberCount = 20.0;

  // 시니어모드에 따른 폰트 크기
  static const double defaultFontSize = 1.0;
  static const double defaultMinFontSize = 0.5;
  static const double defaultMaxFontSize = 2.0;
  static const double seniorModeMinFontSize = 1.5;
  static const double seniorModeMaxFontSize = 2.5;

  // 아이콘 크기
  static const double smallIconSize = 16.0;
  static const double defaultIconSize = 24.0;
  static const double mediumIconSize = 32.0;
  static const double largeIconSize = 48.0;
  static const double xLargeIconSize = 64.0;

  // 비어있는 이미지 모음
  static const String basicEmptyImg =
      "assets/images/illustration/empty-removebg.png";

  // 이모지 목록
  static const List<String> emojiList = ["😀", "🤔", "😍", "😎", "😭", "😡"];

  // 이메일 정규식
  static final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  // 비밀번호 규칙 정규식 (8자 이상, 영문, 숫자, 특수문자 포함)
  static final RegExp passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$',
  );

  // 특수문자 포함 여부 정규식
  static final RegExp specialCharRegExp = RegExp(
    r'[!@#$%^&*()_+]',
  );

  // 푸시 채널
  static const String pushTodoStartTopic = "TODO_START";
  static const String pushTodoEndTopic = "TODO_END";

  // 튜토리얼 구분값
  static const String tutorialMain = "mainViewTutorial2";
  static const String tutorialTodo = "todoTutorial1";

  // 최초 기동 여부
  static const String isFirstInstall = "isFirstInstall2";

  // 온보딩 이미지 url
  static const String onboardingImg1 =
      "https://wdyjvrbtlcclnehrhskq.supabase.co/storage/v1/object/public/onboarding/onboarding/1.png";
  static const String onboardingImg2 =
      "https://wdyjvrbtlcclnehrhskq.supabase.co/storage/v1/object/public/onboarding/onboarding/2.png";
  static const String onboardingImg3 =
      "https://wdyjvrbtlcclnehrhskq.supabase.co/storage/v1/object/public/onboarding/onboarding/3.png";
  static const String onboardingImg4 =
      "https://wdyjvrbtlcclnehrhskq.supabase.co/storage/v1/object/public/onboarding/onboarding/4.png";
  static const String onboardingImg5 =
      "https://wdyjvrbtlcclnehrhskq.supabase.co/storage/v1/object/public/onboarding/onboarding/5.png";
}
