sealed class AppFailure {
  final String message;
  const AppFailure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends AppFailure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'No internet connection']);

  factory NetworkFailure.fromException(Object e) {
    return NetworkFailure(e.toString());
  }
}

class AuthFailure extends AppFailure {
  const AuthFailure([super.message = 'Authentication failed']);
}

class VpnFailure extends AppFailure {
  const VpnFailure([super.message = 'VPN detected. Please disable VPN to continue.']);
}

class ValidationFailure extends AppFailure {
  final Map<String, String>? fieldErrors;
  const ValidationFailure(super.message, {this.fieldErrors});
}

class CacheFailure extends AppFailure {
  const CacheFailure([super.message = 'Cache error']);
}
