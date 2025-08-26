import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/initial_model.dart';
import '../repos/initial_repo.dart';

final initialViewModelProvider =
    StateNotifierProvider<InitialViewModel, InitialModel>((ref) {
  return InitialViewModel(repo: InitialRepoImpl());
});

class InitialViewModel extends StateNotifier<InitialModel> {
  InitialViewModel({required this.repo}) : super(InitialModel.empty());

  final InitialRepo repo;

  Future<void> signInWithGoogle() async {
    await repo.signInWithGoogle();
  }

  Future<void> signInWithApple() async {
    await repo.signInWithApple();
  }
}
