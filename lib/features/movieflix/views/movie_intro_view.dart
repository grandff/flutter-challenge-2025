import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';

import '../view_model/movieflix_view_model.dart';
import '../widgets/movie_card_slider_widget.dart';

class MovieIntroView extends ConsumerStatefulWidget {
  const MovieIntroView({super.key});

  @override
  ConsumerState<MovieIntroView> createState() => _MovieIntroViewState();
}

class _MovieIntroViewState extends ConsumerState<MovieIntroView>
    with TickerProviderStateMixin {
  String _currentBackgroundUrl = '';
  bool _showDetailView = false;
  int _currentMovieIndex = 0;
  late AnimationController _slideController;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<Offset> _detailSlideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // 카드 영역: 아래로 슬라이드
    _cardSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1), // 아래로 이동
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOutCubic,
    ));

    // 상세 화면: 위에서 아래로 슬라이드
    _detailSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1), // 위에서 시작
      end: Offset.zero, // 중앙에 정착
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _onBackgroundChange(String posterUrl) {
    setState(() {
      _currentBackgroundUrl = posterUrl;
    });
  }

  void _onMovieIndexChange(int index) {
    setState(() {
      _currentMovieIndex = index;
    });
  }

  void _showDetailScreen() {
    setState(() {
      _showDetailView = true;
    });
    _slideController.forward();
  }

  void _hideDetailView() {
    _slideController.reverse().then((_) {
      setState(() {
        _showDetailView = false;
      });
    });
  }

  Widget _buildDetailView(MovieflixState state) {
    if (state.popular.isEmpty) return const SizedBox.shrink();

    final movies = state.popular.take(5).toList();
    final movie = movies[_currentMovieIndex]; // 현재 선택된 영화 사용

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.9),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 하단 화살표
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _hideDetailView,
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      color: Colors.white,
                      size: 36,
                    ),
                  )
                      .animate(key: ValueKey('arrow_${movie.id}'))
                      .fadeIn(delay: 300.ms, duration: 600.ms)
                      .scale(
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1, 1)),
                ],
              ),
            ),

            // 스크롤 가능한 상세 내용
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                        .animate(key: ValueKey('title_${movie.id}'))
                        .fadeIn(delay: 500.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 20),

                    // 내용
                    Text(
                      movie.overview.isNotEmpty
                          ? movie.overview
                          : '영화 설명이 없습니다.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.6,
                      ),
                    )
                        .animate(key: ValueKey('overview_${movie.id}'))
                        .fadeIn(delay: 1000.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 30),

                    // 이미지
                    if (movie.posterUrl.isNotEmpty)
                      Center(
                        child: Container(
                          height: 400,
                          width: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              movie.posterUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[800],
                                  child: const Icon(
                                    Icons.movie,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                          .animate(key: ValueKey('poster_${movie.id}'))
                          .fadeIn(delay: 1500.ms, duration: 600.ms)
                          .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1, 1)),

                    const SizedBox(height: 30),

                    // 평점
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '/ 10',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate(key: ValueKey('rating_${movie.id}'))
                        .fadeIn(delay: 2000.ms, duration: 600.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 30),

                    // 장르 정보
                    if (movie.genres.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '장르',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: movie.genres.map((genre) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[600],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  genre,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )
                          .animate(key: ValueKey('genres_${movie.id}'))
                          .fadeIn(delay: 2500.ms, duration: 600.ms)
                          .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(movieflixProvider);

    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지 (포스터와 동일, 애니메이션 적용)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            child: _currentBackgroundUrl.isNotEmpty
                ? Container(
                    key: ValueKey(_currentBackgroundUrl),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(_currentBackgroundUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.grey[900]!,
                          Colors.grey[800]!,
                        ],
                      ),
                    ),
                  ),
          ),

          // 메인 콘텐츠 (카드 영역)
          SlideTransition(
            position: _cardSlideAnimation,
            child: SafeArea(
              child: Column(
                children: [
                  // 상단 앱바 영역 (위쪽 화살표 아이콘)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _showDetailScreen,
                          child: const HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowUp01,
                            color: Colors.white,
                            size: 36, // 24에서 36으로 크기 증가
                          ),
                        ).animate().fadeIn(duration: 500.ms).scale(
                              begin: const Offset(0.5, 0.5),
                              end: const Offset(1, 1),
                            ),
                      ],
                    ),
                  ),

                  // 로딩 인디케이터
                  if (state.isLoading)
                    LinearProgressIndicator(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),

                  const SizedBox(height: 20),

                  // 영화 카드 슬라이더
                  Expanded(
                    child: state.popular.isNotEmpty
                        ? MovieCardSlider(
                            movies: state.popular.take(5).toList(),
                            onBookingTap: () => _handleBookingTap(context),
                            onBackgroundChange: _onBackgroundChange,
                            onMovieIndexChange: _onMovieIndexChange,
                          )
                        : !state.isLoading
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.movie_outlined,
                                      size: 64,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '영화 정보를 불러올 수 없습니다',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ).animate().fadeIn(duration: 500.ms),
                              )
                            : const SizedBox.shrink(),
                  ),

                  // 에러 메시지
                  if (state.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red[900]!.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red[400]!),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[200],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                state.errorMessage!,
                                style: TextStyle(
                                  color: Colors.red[100],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideY(begin: 0.3, end: 0),
                    ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // 상세 화면
          if (_showDetailView)
            Positioned.fill(
              child: SlideTransition(
                position: _detailSlideAnimation,
                child: _buildDetailView(state),
              ),
            ),

          // 새로고침 제스처
          Positioned.fill(
            child: RefreshIndicator(
              onRefresh: () => ref.read(movieflixProvider.notifier).loadAll(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBookingTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '예매하기',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('영화 예매 사이트로 이동하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _launchBookingUrl();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('이동'),
          ),
        ],
      ),
    );
  }

  void _launchBookingUrl() async {
    const url = 'https://www.cgv.co.kr';
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('URL 실행 실패: $e');
    }
  }
}
