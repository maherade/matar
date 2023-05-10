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
    Map<String, dynamic> ?data,
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
    Map<String, dynamic>? data,
    String? language,
    Map<String, dynamic>? query,
    required String? token,
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
// /static Future<String> deleteUser(String apiUrl, String userId, String token) async {
//   final dio = Dio();
//   dio.options.headers = {'Authorization': 'Bearer $token'};
//   try {
//     final response = await dio.delete('$apiUrl/users/$userId');
//     if (response.statusCode == 200) {
//       return 'User with ID $userId was deleted successfully';
//     } else {
//       return 'Error deleting user with ID $userId: ${response.data}';
//     }
//   } on DioError catch (e) {
//     return 'Error deleting user with ID $userId: ${e.message}';
//   }
// }
}