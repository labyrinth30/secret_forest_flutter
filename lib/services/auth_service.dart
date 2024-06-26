import 'package:dio/dio.dart';
import 'package:secret_forest_flutter/common/data.dart';

class AuthService {
  static Future<Response<dynamic>> signIn(
      String email, String password, Dio dio) async {
    try {
      final response = await dio.post(
        '$authIp/auth/login/email',
        data: {
          "email": email,
          "password": password,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
            "Accept": "application/json",
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('로그인 요청에 실패하였습니다.');
    }
  }

  static Future<bool> checkUserIsLogin(Dio dio) async {
    try {
      final response = await dio.post(
        'http://localhost:3001/auth/token/access',
      );
      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
