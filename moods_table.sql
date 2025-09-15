-- moods 테이블 생성 SQL
-- 이 SQL을 Supabase SQL Editor에서 실행하세요

-- 무드 테이블 (moods)
DROP TABLE IF EXISTS moods;
CREATE TABLE IF NOT EXISTS moods (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    emoji TEXT NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS (Row Level Security) 활성화
ALTER TABLE moods ENABLE ROW LEVEL SECURITY;

-- moods 테이블 RLS 정책
CREATE POLICY "Users can view their own moods" ON moods
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own moods" ON moods
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own moods" ON moods
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own moods" ON moods
    FOR DELETE USING (auth.uid() = user_id);

-- updated_at 자동 갱신 트리거
CREATE TRIGGER update_moods_updated_at
    BEFORE UPDATE ON moods
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 성능 최적화를 위한 인덱스
CREATE INDEX IF NOT EXISTS moods_user_id_idx ON moods(user_id);
CREATE INDEX IF NOT EXISTS moods_created_at_idx ON moods(created_at DESC);

-- 샘플 데이터 (선택사항)
-- INSERT INTO moods (user_id, emoji, description) VALUES
-- ('your-user-id-here', '😊', '오늘은 정말 좋은 하루였어요!');

