class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(isLoading: false, isAuthenticated: false);
  }

  AuthState copyWith({bool? isLoading, bool? isAuthenticated, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
    );
  }
}
