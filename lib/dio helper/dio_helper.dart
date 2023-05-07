import 'package:dio/dio.dart';

class ShopDioHelper {
  static late Dio dio;

  static shopDioInit() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://admin.rain-app.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? language,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept-Language': language,
      'Authorization': token,
    };
    final res = await dio.get(
      url,
      queryParameters: query,
    );
    return res;
  }

  static Future<Response> postData({
    required String url,
    var data,
    String? language,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': language,
      'Authorization': token,
    };
    var res = await dio.post(
      url,
      data: data,
      queryParameters: query,
    );
    return res;
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    required String language,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': language,
      'Authorization': token,
    };
    return await dio.put(
      url,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> deleteData({
    required String url,
    required Map<String, dynamic> data,
    required String language,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang': language,
      'Authorization': token,
    };
    return await dio.delete(
      url,
    );
  }
}
