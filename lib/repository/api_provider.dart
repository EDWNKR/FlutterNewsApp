import 'package:dio/dio.dart';
import 'package:flutternewsapp/models/article_response.dart';
import 'package:flutternewsapp/utils/logging_interceptor.dart';

class ApiProvider {

  //final String _endpoint = "https://newsapi.org/v2/everything?q=technology&apiKey=b5705aa5ea6f4062980f81d68940071b";
  final String _endpoint = "https://newsapi.org/v2/everything";
  final String _apiKey= "b5705aa5ea6f4062980f81d68940071b";
  Dio _dio;

  //for get data from endpoint and response as JSON
  Future<ArticleResponse> getNews(String query) async {
    try {
      Response response = await _dio.get("${_endpoint}?q=${query}&apiKey=${_apiKey}");
      return ArticleResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return ArticleResponse.withError(_handleError(error));
    }
  }

  //for logging interceptor on log cat, this will be important to tracing response data from endpoint
  ApiProvider() {
    BaseOptions options = BaseOptions(receiveTimeout: 5000, connectTimeout: 5000);
    _dio = Dio(options);
    _dio.interceptors.add(LoggingInterceptor());
  }

  //For error handling
  String _handleError(Error error) {
    String errorDescription = "";
    if (error is DioError) {
      DioError dioError = error as DioError;
      switch (dioError.type) {
        case DioErrorType.CANCEL:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.DEFAULT:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.RESPONSE:
          errorDescription =
              "Received invalid status code: ${dioError.response.statusCode}";
          break;
        case DioErrorType.SEND_TIMEOUT:
          errorDescription = "Send timeout in connection with API server";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }
}
