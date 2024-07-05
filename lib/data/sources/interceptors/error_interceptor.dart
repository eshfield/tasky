import 'package:dio/dio.dart';

const errorText = 'unsynchronized data';
const errorMessage = 'Unsynchronized data error';

class UnsynchronizedDataException extends DioException {
  UnsynchronizedDataException({required super.requestOptions, super.message});
}

final errorInterceptor = InterceptorsWrapper(
  onError: (error, handler) {
    if (error.response?.data != null) {
      final serverErrorText = error.response!.data.toString();
      if (serverErrorText.contains(errorText)) {
        final unsynchronizedDataError = UnsynchronizedDataException(
          requestOptions: error.requestOptions,
          message: errorMessage,
        );
        return handler.next(unsynchronizedDataError);
      }
    }
    return handler.next(error);
  },
);
