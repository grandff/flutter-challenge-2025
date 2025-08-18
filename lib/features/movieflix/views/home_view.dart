import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie_model.dart';
import '../view_model/movieflix_view_model.dart';
import 'detail_view.dart';
import '../widgets/movie_poster_widget.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(movieflixProvider);

    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
        onRefresh: () => ref.read(movieflixProvider.notifier).loadAll(),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            if (state.isLoading) const LinearProgressIndicator(),
            _Section(
              title: 'Popular Movies',
              movies: state.popular,
              showTitle: false,
              aspectRatio: 16 / 9,
              cardWidth: 360,
            ),
            _Section(
              title: 'Now in Cinemas',
              movies: state.nowPlaying,
            ),
            _Section(
              title: 'Coming Soon',
              movies: state.comingSoon,
            ),
            if (state.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<MovieModel> movies;
  final bool showTitle;
  final double aspectRatio;
  final double cardWidth;

  const _Section({
    required this.title,
    required this.movies,
    this.showTitle = true,
    this.aspectRatio = 2 / 3,
    this.cardWidth = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: _calculateSectionHeight(),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MoviePosterCard(
                movie: movie,
                showTitle: showTitle,
                aspectRatio: aspectRatio,
                width: cardWidth,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailView(movieId: movie.id),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: movies.length,
          ),
        ),
      ],
    );
  }

  double _calculateSectionHeight() {
    final posterHeight = cardWidth / aspectRatio;
    final titleHeight = showTitle ? 42.0 : 0.0; // approx for up to 2 lines
    const spacingAboveTitle = 8.0;
    const double ratingRowHeight = 20.0;
    const spacingBelowTitle = 4.0;
    final total = posterHeight +
        spacingAboveTitle +
        titleHeight +
        (showTitle ? spacingBelowTitle : 0.0) +
        ratingRowHeight;
    // Add a small buffer to avoid pixel rounding overflow
    return total + 12.0;
  }
}
