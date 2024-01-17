import 'dart:convert';

import 'package:http/http.dart';

class ApiResponseHandler {
  static Map<String, dynamic> output(Response uriResponse,
      {bool isEncodeRequired = true}) {
    Map<String, dynamic> res = <String, dynamic>{};

    if (uriResponse.statusCode == 200 || uriResponse.statusCode ~/ 100 == 2) {
      res['statusCode'] = uriResponse.statusCode;
      res['result'] =
          isEncodeRequired ? json.decode(uriResponse.body) : uriResponse.body;
      res['error'] = null;
    } else if (uriResponse.statusCode >= 400 && uriResponse.statusCode <= 500) {
      res['statusCode'] = uriResponse.statusCode;
      res['result'] = null;
      res['error'] = json.decode(uriResponse.body);
    } else {
      res['result'] = null;
      res['error'] = "something went wrong";
    }

    print("Response - $res");

    return res;
  }

  static Map<String, dynamic> outputError() {
    Map<String, dynamic> res = Map<String, dynamic>();
    res['result'] = null;
    res['error'] = "Something went wrong";

    print("Response error state - $res");

    return res;
  }
}
