import 'package:clipy/networking/api_response_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  static const baseAuthUrl =
      kDebugMode ? "https://dev-api.tricket.in/" : "https://api.tricket.in/";
  static const baseUrl = kDebugMode
      ? "https://tricgameppe.azurewebsites.net/api/"
      : "https://tricgameprod.azurewebsites.net/api/";

  var client = http.Client();

  Future<Map<String, dynamic>> get(String endPoint) async {
    String urlString = baseUrl + endPoint;
    Uri url = Uri.parse(urlString);

    try {
      var uriResponse = await client.get(
        url,
        headers: await _getHeaders(true),
      );
      return ApiResponseHandler.output(uriResponse);
    } catch (e) {
      return ApiResponseHandler.outputError();
    }
  }

  Future<Map<String, dynamic>> post(
    String endPoint, {
    Map<String, dynamic>? payload,
    bool isUserIdReqinPayload = true,
    bool isEncodeRequired = true,
    bool isAuthUrl = false,
  }) async {
    String urlString = (isAuthUrl ? baseAuthUrl : baseUrl) + endPoint;
    Uri url = Uri.parse(urlString);

    Map<String, dynamic> _payLoad = {
      // "user_id": FirebaseAuth.instance.currentUser?.uid
    };

    if (payload != null && isUserIdReqinPayload) {
      _payLoad.addAll(payload);
    }

    Map<String, String> header = await _getHeaders(true);

    try {
      var uriResponse = await client.post(
        url,
        headers: header,
        body: _payLoad,
      );

      return ApiResponseHandler.output(uriResponse,
          isEncodeRequired: isEncodeRequired);
    } catch (e) {
      return ApiResponseHandler.outputError();
    }
  }

  Future<Map<String, String>> _getHeaders(forceRefresh) async {
    Map<String, String> headers = {
      'Accept': 'application/json',
    };

    // String? token = await FirebaseAuth.instance.currentUser?.getIdToken(true);

    // if (token != null) {
    //   headers.putIfAbsent('Authorization', () => 'Bearer $token');
    // }

    return headers;
  }
}
