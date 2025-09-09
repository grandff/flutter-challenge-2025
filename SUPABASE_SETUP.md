# Supabase 설정 가이드

## 1. Supabase 프로젝트 설정

1. [Supabase](https://supabase.com)에서 새 프로젝트를 생성합니다.
2. 프로젝트 설정에서 URL과 anon key를 복사합니다.

## 2. Flutter 앱 설정

### 2.1 Supabase 설정 파일 업데이트

`lib/core/config/supabase_config.dart` 파일을 열고 실제 Supabase 정보로 업데이트하세요:

```dart
class SupabaseConfig {
  static const String url = 'https://your-project-id.supabase.co';
  static const String anonKey = 'your-anon-key-here';
}
```

### 2.2 데이터베이스 스키마 설정

1. Supabase 대시보드의 SQL Editor로 이동합니다.
2. `supabase_schema.sql` 파일의 내용을 복사하여 실행합니다.

**중요**: 이 스키마는 `handle_new_user()` 트리거 함수를 포함합니다. 이 트리거는 `auth.users` 테이블에 새 사용자가 생성될 때 자동으로 `members` 테이블에 프로필을 생성합니다.

### 2.3 Storage 설정 (이미지 업로드용)

1. Supabase 대시보드의 Storage 섹션으로 이동합니다.
2. "Create a new bucket" 버튼을 클릭합니다.
3. 버킷 이름을 `medias`로 설정하고 "Public bucket"을 체크합니다.
4. 생성된 버킷에 대해 다음 정책을 설정합니다:

```sql
-- Storage 정책 설정
CREATE POLICY "Anyone can view medias" ON storage.objects FOR SELECT USING (bucket_id = 'medias');
CREATE POLICY "Authenticated users can upload medias" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'medias' AND auth.role() = 'authenticated');
CREATE POLICY "Users can update their own medias" ON storage.objects FOR UPDATE USING (bucket_id = 'medias' AND auth.uid()::text = (storage.foldername(name))[1]);
CREATE POLICY "Users can delete their own medias" ON storage.objects FOR DELETE USING (bucket_id = 'medias' AND auth.uid()::text = (storage.foldername(name))[1]);
```

## 3. 기능 설명

### 3.1 인증 시스템
- **로그인**: 이메일/비밀번호로 로그인
- **회원가입**: 이메일과 비밀번호만으로 간단한 회원가입
- **자동 프로필 생성**: Supabase 트리거가 회원가입 시 자동으로 `members` 테이블에 프로필 생성
- **자동 리다이렉트**: 로그인 상태에 따라 자동으로 적절한 화면으로 이동

### 3.2 글쓰기 시스템
- **게시글 작성**: 텍스트와 이미지 첨부 가능
- **사용자 정보 표시**: 로그인된 사용자의 이메일과 아바타 표시
- **이미지 업로드**: Supabase Storage를 통한 이미지 저장
- **실시간 저장**: 게시글을 Supabase `posts` 테이블에 저장

### 3.3 보안
- Row Level Security (RLS) 적용
- 사용자는 자신의 프로필만 조회/수정 가능
- JWT 토큰 기반 인증

### 3.4 UI/UX
- Meta 스타일의 로그인 화면
- 로딩 상태 표시
- 에러 처리 및 사용자 피드백

## 4. 사용 방법

### 4.1 회원가입 및 로그인
1. 앱을 실행하면 로그인 화면이 표시됩니다.
2. "Create new account" 버튼을 눌러 회원가입을 진행합니다.
3. 회원가입 완료 후 자동으로 메인 화면으로 이동합니다.
4. 로그인 후에는 Threads 메인 화면이 표시됩니다.

### 4.2 글쓰기 기능
1. 메인 화면 하단의 "+" 버튼을 클릭합니다.
2. 글쓰기 화면에서 로그인된 사용자의 이메일과 아바타가 표시됩니다.
3. 텍스트를 입력하고 필요시 이미지를 첨부할 수 있습니다.
4. "Post" 버튼을 클릭하여 게시글을 저장합니다.
5. 성공적으로 저장되면 메인 화면으로 돌아갑니다.

## 5. 파일 구조

```
lib/
├── core/
│   ├── config/
│   │   └── supabase_config.dart    # Supabase 설정
│   └── supabase_client.dart        # Supabase 클라이언트
├── features/
│   ├── auth/
│   │   ├── models/
│   │   │   └── user_model.dart     # 사용자 모델
│   │   ├── repos/
│   │   │   └── auth_repo.dart      # 인증 레포지토리
│   │   ├── view_model/
│   │   │   └── auth_view_model.dart # 인증 뷰모델
│   │   └── views/
│   │       ├── login_view.dart     # 로그인 화면
│   │       └── signup_view.dart    # 회원가입 화면
│   └── threads/
│       └── home/
│           ├── models/
│           │   └── post_model.dart # 게시글 모델
│           ├── repos/
│           │   └── post_repo.dart  # 게시글 레포지토리
│           ├── utils/
│           │   ├── user_utils.dart # 사용자 유틸리티
│           │   └── image_upload_utils.dart # 이미지 업로드 유틸리티
│           ├── view_model/
│           │   └── post_view_model.dart # 게시글 뷰모델
│           └── widgets/
│               └── create_post_bottom_sheet.dart # 글쓰기 바텀시트
└── common/
    └── auth_guard.dart             # 인증 가드
```

## 6. 주의사항

- 실제 배포 시에는 환경 변수나 보안 파일을 사용하여 API 키를 관리하세요.
- 프로덕션 환경에서는 추가적인 보안 설정을 고려하세요.
- 사용자 데이터는 GDPR 및 개인정보보호법을 준수하여 처리하세요.


