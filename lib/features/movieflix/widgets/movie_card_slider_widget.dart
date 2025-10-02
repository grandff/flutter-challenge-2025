import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/movie_model.dart';

class MovieCardSlider extends StatefulWidget {
  final List<MovieModel> movies;
  final VoidCallback? onBookingTap;
  final Function(String)? onBackgroundChange;
  final Function(int)? onMovieIndexChange;

  const MovieCardSlider({
    super.key,
    required this.movies,
    this.onBookingTap,
    this.onBackgroundChange,
    this.onMovieIndexChange,
  });

  @override
  State<MovieCardSlider> createState() => _MovieCardSliderState();
}

class _MovieCardSliderState extends State<MovieCardSlider> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        viewportFraction: 0.8); // 0.85에서 0.8로 조정하여 양옆 카드 더 많이 보이게

    // 초기 배경 설정
    if (widget.movies.isNotEmpty && widget.onBackgroundChange != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onBackgroundChange!(widget.movies[0].posterUrl);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });

    // 배경 이미지 변경 알림
    if (widget.onBackgroundChange != null && widget.movies.isNotEmpty) {
      widget.onBackgroundChange!(widget.movies[index].posterUrl);
    }

    // 영화 인덱스 변경 알림
    if (widget.onMovieIndexChange != null) {
      widget.onMovieIndexChange!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) {
      return const SizedBox(
        height: 600,
        child: Center(
          child: Text('영화 정보를 불러오는 중...'),
        ),
      );
    }

    return SizedBox(
      height: 600,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          final movie = widget.movies[index];
          final isActive = index == _currentIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.symmetric(
              horizontal: 12, // 8에서 12로 증가하여 카드 간 간격 확보
              vertical: isActive ? 0 : 60, // 30에서 60으로 증가하여 더 큰 축소 효과
            ),
            child: Transform.scale(
              scale: isActive ? 1.0 : 0.85, // 비활성 카드 크기 축소
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200), // 더 빠른 fade out
                opacity: isActive ? 1.0 : 0.6, // 비활성 카드 더 흐리게
                child: MovieCard(
                  movie: movie,
                  isActive: isActive,
                  onBookingTap: widget.onBookingTap,
                ),
              ),
            ),
          ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.3, end: 0);
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final bool isActive;
  final VoidCallback? onBookingTap;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isActive,
    this.onBookingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 정보 카드 (더 넓음, 포스터와 겹침)
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.only(top: 120), // 포스터와 겹치도록 조정
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // 상단 정보 영역
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 200, // 포스터가 겹치는 부분을 고려해서 제목 위치 조정
                      left: 20,
                      right: 20,
                      bottom: 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 영화 제목 (포스터 겹침 영역 아래에 배치)
                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                            .animate(key: ValueKey('card_title_${movie.id}'))
                            .fadeIn(delay: 300.ms, duration: 500.ms)
                            .slideY(begin: 0.3, end: 0),

                        const SizedBox(height: 12),

                        // 평점
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '/ 10',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        )
                            .animate(key: ValueKey('card_rating_${movie.id}'))
                            .fadeIn(delay: 600.ms, duration: 500.ms)
                            .slideX(begin: -0.3, end: 0),

                        const SizedBox(height: 16),

                        // 영화 설명 (3줄 제한, 툴팁 기능)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showDescriptionTooltip(
                                context, movie.overview),
                            child: Text(
                              movie.overview.isNotEmpty
                                  ? movie.overview
                                  : '영화 설명이 없습니다.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                              maxLines: 3, // 3줄 제한
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                              .animate(key: ValueKey('card_desc_${movie.id}'))
                              .fadeIn(delay: 900.ms, duration: 500.ms)
                              .slideY(begin: 0.2, end: 0),
                        ),
                      ],
                    ),
                  ),
                ),

                // 예매 버튼 (카드 하단에 완전히 통합)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onBookingTap,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '예매하기',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    .animate(key: ValueKey('card_button_${movie.id}'))
                    .fadeIn(delay: 1200.ms, duration: 500.ms)
                    .slideY(begin: 0.3, end: 0),
              ],
            ),
          ),
        ),

        // 포스터 이미지 (더 좁음, 위에 겹침)
        Positioned(
          top: 0,
          left: 50,
          right: 50,
          child: Container(
            height: 300, // 세로 길이 1.5배 확장
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8), // 하단 그림자
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: movie.posterUrl.isNotEmpty
                  ? AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Image.network(
                        movie.posterUrl,
                        key: ValueKey(movie.id),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.movie,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.movie,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
            ),
          )
              .animate(key: ValueKey('card_poster_${movie.id}'))
              .fadeIn(delay: 100.ms, duration: 500.ms)
              .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                  curve: Curves.easeOut),
        ),
      ],
    );
  }

  void _showDescriptionTooltip(BuildContext context, String description) {
    if (description.isEmpty) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            movie.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red[600],
              ),
              child: const Text('닫기'),
            ),
          ],
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
