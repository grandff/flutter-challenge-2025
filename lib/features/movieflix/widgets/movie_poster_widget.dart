import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/movie_model.dart';

class MoviePosterCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback? onTap;
  final bool showTitle;
  final double aspectRatio;
  final double width;

  const MoviePosterCard({
    super.key,
    required this.movie,
    this.onTap,
    this.showTitle = true,
    this.aspectRatio = 2 / 3,
    this.width = 140,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: aspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: movie.posterUrl.isEmpty
                    ? Container(color: Colors.grey.shade300)
                    : Image.network(
                        movie.posterUrl,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            if (showTitle) ...[
              AutoSizeText(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
            ],
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  movie.voteAverage.toStringAsFixed(1),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.grey[700]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
