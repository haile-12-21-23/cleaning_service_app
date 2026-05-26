class TokenResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  TokenResponse({
    required this.accessToken,
    required this.tokenType,
    required this.refreshToken,
  });
  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
      tokenType: json['token_type'],
    );
  }
}
