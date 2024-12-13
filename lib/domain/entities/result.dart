abstract class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  final dynamic errorType;

  const Failure({required this.message, this.errorType});
}

extension ResultExtension<T> on Result<T> {
  R fold<R>({
    required R Function(T) onSuccess,
    required R Function(String, dynamic) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else if (this is Failure<T>) {
      return onFailure((this as Failure<T>).message, (this as Failure<T>).errorType);
    } else {
      return onFailure("Unexpected error", null);
    }
  }
}
