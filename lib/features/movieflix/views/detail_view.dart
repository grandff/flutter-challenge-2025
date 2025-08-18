import 'dart:async';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/movieflix_view_model.dart';

class DetailView extends ConsumerStatefulWidget {
  final int movieId;
  const DetailView({super.key, required this.movieId});

  @override
  ConsumerState<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends ConsumerState<DetailView> {
  Color _textColor = Colors.white;
  int? _computedForId;

  @override
  Widget build(BuildContext context) {
    final asyncDetail = ref.watch(movieDetailProvider(widget.movieId));

    return asyncDetail.when(
      data: (movie) {
        if (_computedForId != movie.id && movie.posterUrl.isNotEmpty) {
          _computedForId = movie.id;
          _computeTextColor(movie.posterUrl);
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: null,
            leadingWidth: 140,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: _textColor),
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: _textColor),
                label: Text(
                  'Back to List',
                  style:
                      TextStyle(color: _textColor, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Background poster image
              if (movie.posterUrl.isNotEmpty)
                Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                )
              else
                Container(color: Colors.grey.shade300),

              // Subtle gradient overlay to improve readability
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black38,
                      Colors.black26,
                      Colors.black45,
                    ],
                  ),
                ),
              ),

              // Foreground content
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, kToolbarHeight + 8, 16, 96),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        movie.title,
                        maxLines: 2,
                        minFontSize: 18,
                        style: TextStyle(
                          color: _textColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 34,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 18, color: Colors.amber),
                          const SizedBox(width: 6),
                          AutoSizeText(
                            movie.voteAverage.toStringAsFixed(1),
                            maxLines: 1,
                            minFontSize: 12,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: _textColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: movie.genres
                            .map((g) => Chip(
                                  label: Text(
                                    g,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  backgroundColor: _textColor.withOpacity(0.12),
                                  side: BorderSide(
                                      color: _textColor.withOpacity(0.24)),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      AutoSizeText(
                        movie.overview.isEmpty ? '설명이 없습니다.' : movie.overview,
                        maxLines: 6,
                        minFontSize: 12,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: _textColor),
                      ),
                      const Spacer(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              // Bottom fixed Buy ticket button overlayed on poster
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Buy ticket',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('오류: $e')),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _computeTextColor(String url) async {
    try {
      final imageProvider = NetworkImage(url);
      const config = ImageConfiguration();
      final completer = Completer<ui.Image>();
      final stream = imageProvider.resolve(config);
      ImageStreamListener? listener;
      listener = ImageStreamListener((imageInfo, _) {
        stream.removeListener(listener!);
        completer.complete(imageInfo.image);
      }, onError: (error, stackTrace) {
        stream.removeListener(listener!);
        completer.completeError(error, stackTrace);
      });
      stream.addListener(listener);

      final uiImage = await completer.future;
      final byteData =
          await uiImage.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();
      final width = uiImage.width;
      final height = uiImage.height;

      // Sample pixels in a grid to estimate brightness
      int stepX = (width / 20).clamp(1, width).toInt();
      int stepY = (height / 20).clamp(1, height).toInt();

      double luminanceSum = 0;
      int samples = 0;
      for (int y = 0; y < height; y += stepY) {
        for (int x = 0; x < width; x += stepX) {
          final index = (y * width + x) * 4;
          if (index + 3 >= bytes.length) continue;
          final r = bytes[index];
          final g = bytes[index + 1];
          final b = bytes[index + 2];
          // Perceived luminance approximation
          final luminance = 0.299 * r + 0.587 * g + 0.114 * b;
          luminanceSum += luminance;
          samples++;
        }
      }

      if (samples == 0) return;
      final avg = luminanceSum / samples; // 0..255
      final chosen = avg > 140 ? Colors.black : Colors.white;
      if (!mounted) return;
      setState(() {
        _textColor = chosen;
      });
    } catch (_) {
      // Fallback
      if (!mounted) return;
      setState(() {
        _textColor = Colors.white;
      });
    }
  }
}
