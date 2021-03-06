import 'package:chmt/utils/utility.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_config/flutter_config.dart';

class APIPath {
  static String houseHold = r'hodan/';
  static String province = r'tinh/';
  static String district = r'huyen/';
  static String commune = r'xa/';
  static String rescuer = r'cuuho/';
}

class APIMethod {
  static Dio _dio = APIMethod.dioClient();

  static String baseUrl = FlutterConfig.get('API_URL');

  static Dio dioClient() {
    Dio dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.receiveTimeout = 20000;
    dio.options.connectTimeout = 20000;
    dio.options.headers = {
      'Authorization': 'Token ' + FlutterConfig.get('TOKEN'),
    };
    return dio;
  }

  /// GET
  static Future<dynamic> getData(
      String subPath, Map<String, dynamic> params) async {

    logger.info(_dio.options.baseUrl);
    logger.info('>>>$subPath<<< PARAMS: $params');

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw r'Không có kết nối mạng';
      }

      Response res = await _dio.get(subPath, queryParameters: params);

      logger.info(subPath);
      logger.info(res.request.queryParameters);
      logger.info('>>>$subPath<<< RESPONSE: ${res.data}');

      return (res.data);
    } catch (e) {
      throw e;
    }
  }

  /// POST
  static Future<dynamic> postData(String subPath, Map params) async {
    logger.info(_dio.options.baseUrl);
    logger.info('>>>$subPath<<< PARAMS: $params');

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw r'Không có kết nối mạng';
      }

      Response res = await _dio.post(subPath, data: params);

      logger.info('>>>$subPath<<< RESPONSE: ${res.data}');

      return (res.data);
    } catch (e) {
      throw e;
    }
  }

  /// PUT
  static Future<dynamic> putData(String subPath, Map params) async {
    logger.info('>>>$subPath<<< PARAMS: $params');

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw r'Không có kết nối mạng';
      }

      Response res = await _dio.put(subPath, data: params);

      logger.info('>>>$subPath<<< RESPONSE: ${res.data}');

      return (res.data);
    } catch (e) {
      throw e;
    }
  }

  /// PUT
  static Future<dynamic> delete(String subPath, Map params) async {
    logger.info('>>>$subPath<<< PARAMS: $params');

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        throw r'Không có kết nối mạng';
      }

      Response res = await _dio.delete(subPath, data: params);

      logger.info('>>>$subPath<<< RESPONSE: ${res.data}');

      return (res.data);
    } catch (e) {
      throw e;
    }
  }
}
