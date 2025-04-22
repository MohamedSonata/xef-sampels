class ApiResult<L, R> {
  const ApiResult(this.failure, this.value);
  final L? failure;
  final R? value;

  ApiResult.failure(this.failure) : value = null;
  ApiResult.value(this.value) : failure = null;

  when<T>({required T Function(L? failure) onFailure, required T Function(R?) onValue}) {
    
    if (failure != null) {
      return onFailure(failure);
    } else if (value != null) {
      return onValue(value);
    } else {
      throw StateError("Both left and right are null.");
    }
  }
}

abstract class GetDataRepo {
  Future<ApiResult<Failure, List<String>>> getData(bool isSuccess);
}

class GetDataRepoImpl extends GetDataRepo {
  @override
  Future<ApiResult<Failure, List<String>>> getData(bool isSuccess) async {
    if (isSuccess) {
      return ApiResult.value([]);
    } else {
      return ApiResult.failure(AppGlobalException(""));
    }
  }
}

class TestCubit {
  final GetDataRepoImpl repo = GetDataRepoImpl();
  Future<ApiResult<Failure, List<String>>> getData() async {
    final res = await repo.getData(true);

    return res.when(onFailure: (leftValue) {
      return ApiResult.failure(leftValue);
    }, onValue: (rightValue) {
      return ApiResult.value(rightValue);
    });
  }
}

class Failure {
  final String message;
  Failure(this.message);
}

class AppGlobalException extends Failure {
  AppGlobalException(super.message);
}
