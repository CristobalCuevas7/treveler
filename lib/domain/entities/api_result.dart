import 'package:treveler/domain/entities/api_error.dart';
import 'package:treveler/domain/entities/result.dart' as result;

abstract class ApiResult<T> {
  const ApiResult();
}

class Success<T> extends ApiResult<T> {
  final T data;

  const Success(this.data);
}

class Failure<T> extends ApiResult<T> {
  final ApiError error;

  const Failure({required this.error});
}

extension ResultExtension<T> on ApiResult<T> {
  R fold<R>({
    required R Function(T) onSuccess,
    required R Function(ApiError) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else if (this is Failure<T>) {
      return onFailure((this as Failure<T>).error);
    } else {
      return onFailure(ApiError(error: "", message: "", dev: ""));
    }
  }
}

extension ApiResultToDomain<T> on Future<ApiResult<T>> {
  Future<result.Result<T>> toResult() async {
    final apiResult = await this;
    return apiResult.fold<result.Result<T>>(
      onSuccess: (data) => result.Success<T>(data),
      onFailure: (error) => result.Failure<T>(message: error.message, errorType: error.error),
    );
  }
}
