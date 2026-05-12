class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool loggedOut;
  final String? error;

  AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    this.loggedOut = false,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isAuthenticated: false,
      loggedOut: false,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? loggedOut,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      loggedOut: loggedOut ?? this.loggedOut,
      error: error,
    );
  }
}
