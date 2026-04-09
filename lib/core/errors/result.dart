import 'failures.dart';

sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(AppFailure error) = Failure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure error) failure,
  }) {
    return switch (this) {
      Success<T>(data: final d) => success(d),
      Failure<T>(error: final e) => failure(e),
    };
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
    Success<T>(data: final d) => d,
    Failure<T>() => null,
  };

  AppFailure? get errorOrNull => switch (this) {
    Success<T>() => null,
    Failure<T>(error: final e) => e,
  };
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppFailure error;
  const Failure(this.error);
}
