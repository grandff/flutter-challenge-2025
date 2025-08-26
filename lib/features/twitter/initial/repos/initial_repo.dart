abstract class InitialRepo {
  Future<void> signInWithGoogle();
  Future<void> signInWithApple();
}

class InitialRepoImpl implements InitialRepo {
  @override
  Future<void> signInWithApple() async {
    // Placeholder implementation
  }

  @override
  Future<void> signInWithGoogle() async {
    // Placeholder implementation
  }
}
