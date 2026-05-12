class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool loggedOut;
  final bool isInitialized;

  final String? error;

  AuthState({
    required this.isLoading,
    required this.isAuthenticated,
    this.loggedOut = false,
    required this.isInitialized,

    this.error,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isAuthenticated: false,
      isInitialized: false,

      loggedOut: false,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? loggedOut,
    bool? isInitialized,

    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      loggedOut: loggedOut ?? this.loggedOut,
      isInitialized: isInitialized ?? this.isInitialized,

      error: error,
    );
  }
}
