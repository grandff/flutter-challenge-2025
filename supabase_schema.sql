-- Supabase 데이터베이스 스키마
-- 이 파일의 SQL 문을 Supabase SQL Editor에서 실행하세요

-- 사용자 프로필 테이블 (members)
drop table if exists members;
CREATE TABLE IF NOT EXISTS members (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT NOT NULL,
    name TEXT NOT NULL,
    phone TEXT,
    date_of_birth DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 게시글 테이블 (posts)
drop table if exists posts;
CREATE TABLE IF NOT EXISTS posts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    content TEXT NOT NULL,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 무드 테이블 (moods)
drop table if exists moods;
CREATE TABLE IF NOT EXISTS moods (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES public.members(id) ON DELETE CASCADE NOT NULL,
    emoji TEXT NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 새 사용자 생성 시 자동으로 members 테이블에 프로필을 생성하는 함수
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    -- auth.users 테이블에 새 사용자가 생성될 때 members 테이블에 프로필 자동 생성
    INSERT INTO public.members (id, email, name, created_at, updated_at)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'name', split_part(NEW.email, '@', 1)),
        NOW(),
        NOW()
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- auth.users 테이블에 INSERT 트리거 생성
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- RLS (Row Level Security) 정책 설정
ALTER TABLE members ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE moods ENABLE ROW LEVEL SECURITY;

-- members 테이블 정책
CREATE POLICY "Users can view own profile" ON members
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON members
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON members
    FOR INSERT WITH CHECK (auth.uid() = id);

-- posts 테이블 정책
CREATE POLICY "Anyone can view posts" ON posts
    FOR SELECT USING (true);

CREATE POLICY "Users can create their own posts" ON posts
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own posts" ON posts
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own posts" ON posts
    FOR DELETE USING (auth.uid() = user_id);

-- moods 테이블 정책
CREATE POLICY "Users can view their own moods" ON moods
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own moods" ON moods
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own moods" ON moods
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own moods" ON moods
    FOR DELETE USING (auth.uid() = user_id);

-- 프로필 업데이트 시 updated_at 자동 갱신을 위한 트리거
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_members_updated_at
    BEFORE UPDATE ON members
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_posts_updated_at
    BEFORE UPDATE ON posts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_moods_updated_at
    BEFORE UPDATE ON moods
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS members_email_idx ON members(email);
CREATE INDEX IF NOT EXISTS members_phone_idx ON members(phone);
CREATE INDEX IF NOT EXISTS posts_user_id_idx ON posts(user_id);
CREATE INDEX IF NOT EXISTS posts_created_at_idx ON posts(created_at DESC);
CREATE INDEX IF NOT EXISTS moods_user_id_idx ON moods(user_id);
CREATE INDEX IF NOT EXISTS moods_created_at_idx ON moods(created_at DESC);

-- Storage 설정 (이미지 업로드용)
-- Supabase 대시보드의 Storage 섹션에서 'medias' 버킷을 생성하세요
-- 또는 다음 SQL을 실행하여 버킷을 생성할 수 있습니다:

-- INSERT INTO storage.buckets (id, name, public) VALUES ('medias', 'medias', true);

-- Storage 정책 설정
-- CREATE POLICY "Anyone can view medias" ON storage.objects FOR SELECT USING (bucket_id = 'medias');
-- CREATE POLICY "Authenticated users can upload medias" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'medias' AND auth.role() = 'authenticated');
-- CREATE POLICY "Users can update their own medias" ON storage.objects FOR UPDATE USING (bucket_id = 'medias' AND auth.uid()::text = (storage.foldername(name))[1]);
-- CREATE POLICY "Users can delete their own medias" ON storage.objects FOR DELETE USING (bucket_id = 'medias' AND auth.uid()::text = (storage.foldername(name))[1]);

-- 샘플 데이터 (선택사항)
-- INSERT INTO members (id, email, name, phone, date_of_birth) VALUES
-- ('00000000-0000-0000-0000-000000000000', 'test@example.com', 'Test User', '010-1234-5678', '1990-01-01');


