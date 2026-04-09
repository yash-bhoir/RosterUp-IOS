class ApiResponse<T> {
  final bool status;
  final int statusCode;
  final String message;
  final String? errorMessage;
  final T? data;

  ApiResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    this.errorMessage,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      status: json['status'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      errorMessage: json['error_message']?.toString(),
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }
}

class LoginResponseData {
  final String otp;

  LoginResponseData({required this.otp});

  factory LoginResponseData.fromJson(Map<String, dynamic> json) {
    return LoginResponseData(otp: json['otp']?.toString() ?? '');
  }
}

class SignInResponseData {
  final String accessToken;
  final String refreshToken;

  SignInResponseData({required this.accessToken, required this.refreshToken});

  factory SignInResponseData.fromJson(Map<String, dynamic> json) {
    return SignInResponseData(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}
