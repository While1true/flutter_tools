import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio/src/Dio.dart';
import 'package:flutter_tools/Utils/LogUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _HttpUtil http = _HttpUtil("http://10.10.120.241:9080/api-service/");

class _HttpUtil {
  Dio _dio;
  ErrorCatch _errorCatch = DefaultCatch();

  _HttpUtil(String baseUrl, {ErrorCatch errorCatch}) {
    if (errorCatch != null) {
      _errorCatch = errorCatch;
    }
    _dio = new Dio(new Options(
      baseUrl: baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 5000,
    ));

    _dio.interceptor.request.onSend = (Options options) {
      LogUtil.longLog(options.baseUrl+options.path + (options.data??"").toString());
      // Do something before request is sent
      return options; //continue
      // If you want to resolve the request with some custom data，
      // you can return a `Response` object or return `dio.resolve(data)`.
      // If you want to reject the request with a error message,
      // you can return a `DioError` object or return `dio.reject(errMsg)`
    };
    _dio.interceptor.response.onSuccess = (Response response) {
      // Do something with response data
      return response; // continue
    };
    _dio.interceptor.response.onError = (DioError e) {
      // Do something with response error
      return e; //continue
    };
  }

  @override
  clear() {
    interceptor.request.clear();
  }

  @override
  Future<Response<T>> delete<T>(String path,
      {data, Options options, CancelToken cancelToken}) async {
    try {
      return await _dio.delete<T>(path,
          data: data, options: options, cancelToken: cancelToken);
    } catch (e) {
      return _errorCatch.catchHandler<T>(e);
    }
  }

  @override
  Future<Response> download(String urlPath, savePath,
      {OnDownloadProgress onProgress,
      CancelToken cancelToken,
      data,
      Options options}) async {
    try {
      return await _dio.download(urlPath, savePath,
          onProgress: onProgress,
          cancelToken: cancelToken,
          data: data,
          options: options);
    } catch (e) {
      return _errorCatch.catchHandler(e);
    }
  }

  @override
  Future<Response<T>> get<T>(String path,
      {data, Options options, CancelToken cancelToken}) async {
    try {
      return await _dio.get<T>(path,
          data: data, options: options, cancelToken: cancelToken);
    } catch (e) {
      return _errorCatch.catchHandler<T>(e);
    }
  }

  Future<Response<T>> head<T>(String path,
      {data, Options options, CancelToken cancelToken}) async {
    try {
      return await _dio.head<T>(path,
          data: data, options: options, cancelToken: cancelToken);
    } catch (e) {
      return _errorCatch.catchHandler<T>(e);
    }
  }

  @override
  Interceptor get interceptor => _dio.interceptor;

  @override
  lock() {
    interceptor.request.lock();
  }

  @override
  Future<Response<T>> patch<T>(String path,
      {data, Options options, CancelToken cancelToken}) async {
    try {
      return await _dio.patch<T>(path,
          data: data, options: options, cancelToken: cancelToken);
    } catch (e) {
      return _errorCatch.catchHandler<T>(e);
    }
  }

  @override
  Future<Response<T>> post<T>(String path,
      {data, Options options, CancelToken cancelToken}) async {
    try {
      return await _dio.post<T>(path,
          data: data, options: options, cancelToken: cancelToken);
    } catch (e) {
      return _errorCatch.catchHandler<T>(e);
    }
  }

  @override
  Future<Response<T>> put<T>(String path,
      {data, Options options, CancelToken cancelToken}) async {
    try {
      return await _dio.put<T>(path,
          data: data, options: options, cancelToken: cancelToken);
    } catch (e) {
      return _errorCatch.catchHandler<T>(e);
    }
  }

  @override
  Future<Response<T>> reject<T>(err) {
    return _dio.reject<T>(err);
  }

  @override
  Future<Response<T>> request<T>(String path,
      {data, CancelToken cancelToken, Options options}) async {
    try {
      return await _dio.request<T>(path,
          data: data, options: options, cancelToken: cancelToken);
    } catch (e) {
      return _errorCatch.catchHandler<T>(e);
    }
  }

  @override
  Future<Response<T>> resolve<T>(response) {
    return _dio.resolve<T>(response);
  }

  @override
  unlock() {
    interceptor.request.unlock();
  }
}

abstract class ErrorCatch {
  Response<T> catchHandler<T>(Error error);
}

class DefaultCatch implements ErrorCatch {
  @override
  Response<T> catchHandler<T>(Error error) {
    if (error is DioError) {
      if (error.type == DioErrorType.CONNECT_TIMEOUT ||
          error.type == DioErrorType.RECEIVE_TIMEOUT) {
        Fluttertoast.showToast(msg: "连接服务器失败！",toastLength: Toast.LENGTH_LONG,timeInSecForIos: 5);
      } else if (error.type == DioErrorType.RESPONSE) {
        Fluttertoast.showToast(msg: "${error.response.statusCode} 服务器出错",toastLength: Toast.LENGTH_LONG,timeInSecForIos: 5);
      } else {
        if (error.response != null) print(error.response.request);
        print(error.message);
      }
    } else {
      print(error);
    }
    return Response<T>(statusCode: -1);
  }
}
