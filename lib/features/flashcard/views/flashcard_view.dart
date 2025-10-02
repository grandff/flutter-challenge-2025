import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/flashcard_view_model.dart';
import '../widgets/flashcard_widget.dart';
import '../widgets/progress_painter.dart';

class FlashcardView extends ConsumerWidget {
  const FlashcardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(flashcardProvider);
    final viewModel = ref.read(flashcardProvider.notifier);
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      color: state.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: state.isLoading
              ? _buildLoadingWidget(theme)
              : state.flashcards.isEmpty
                  ? _buildEmptyWidget(theme, viewModel)
                  : state.isCompleted
                      ? _buildCompletedWidget(theme, viewModel)
                      : _buildFlashcardContent(
                          context, state, viewModel, theme),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            '플래시 카드를 불러오는 중...',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(ThemeData theme, FlashcardViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              '플래시 카드가 없습니다',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '새로운 플래시 카드를 추가하거나 샘플 데이터를 다시 로드해보세요.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => viewModel.restart(),
              icon: const Icon(Icons.refresh),
              label: const Text('샘플 데이터 다시 로드'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedWidget(ThemeData theme, FlashcardViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.celebration,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              '축하합니다!',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '모든 플래시 카드를 완료했습니다.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => viewModel.restart(),
              icon: const Icon(Icons.replay),
              label: const Text('다시 시작'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashcardContent(
    BuildContext context,
    dynamic state,
    FlashcardViewModel viewModel,
    ThemeData theme,
  ) {
    final currentCard = state.currentCard;

    if (currentCard == null) {
      return _buildEmptyWidget(theme, viewModel);
    }

    return Column(
      children: [
        // 플래시 카드
        Expanded(
          child: Center(
            child: FlashcardWidget(
              card: currentCard,
              nextCard: state.hasNextCard
                  ? state.flashcards[state.currentIndex + 1]
                  : null,
              onTap: () => viewModel.flipCard(),
              onDragUpdate: (deltaX) => viewModel.onCardDragged(deltaX),
              onDragEnd: (deltaX) => viewModel.onCardDropped(deltaX),
            ),
          ),
        ),

        // 하단 진행률 표시줄
        Container(
          padding: const EdgeInsets.all(20.0),
          child: ProgressBarWidget(
            progress: state.progress,
            height: 16.0,
            margin: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
