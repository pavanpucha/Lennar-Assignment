import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:image_viewer/repo/app_repository.dart';

import '../models/picsum_model.dart';

abstract class ApiService {
  Future<PicsumPayload> getNetworkImages();

  bool mockLogin(String username, String password);

  Future<PicsumPayload> getImagesByPage(int page);
}

class PicsumApiService extends ApiService {
  http.Client _httpClient = http.Client();

  PicsumApiService({http.Client? httpClient}) {
    _httpClient = httpClient ?? this._httpClient;
  }

  Map<String, String> q_param(int pageNum) {
    return {"page": pageNum.toString()};
  }

  bool mockLogin(String username, String password) {
    try {
      if (username == "user@lennar.com" && password == "Lennar@123!") {
        print("true");
        return true;
      } else {
        print("false");

        return false;
      }
    } catch (exception) {
      throw exception.toString();
    }
  }

  @override
  Future<PicsumPayload> getNetworkImages() async {
    try {
      final request = await _httpClient
          .get(
            Uri.https("picsum.photos", "v2/list"),
          )
          .timeout(Duration(seconds: 10));
      switch (request.statusCode) {
        case 200:
          localRepository.savePicsumPayload(request.body);
          return PicsumPayload(picsumImageFromJson(request.body));
        case 201:
        case 400:
          throw Exception(["Invalid Request"]);
        case 401:
        case 403:
          throw Exception();
        default:
          throw Exception(["An error occured ${request.statusCode}"]);
      }
    } on TimeoutException catch (timeoutErr) {
      throw Exception(["Network Timeout"]);
    }
  }

  @override
  Future<PicsumPayload> getImagesByPage(int page) async {
    try {
      final request = await _httpClient
          .get(
            Uri.https("picsum.photos", "v2/list", q_param(page)),
          )
          .timeout(Duration(seconds: 10));
      switch (request.statusCode) {
        case 200:
          localRepository.savePicsumPayload(request.body);
          return PicsumPayload(picsumImageFromJson(request.body));
        case 201:
        case 400:
          throw Exception(["Invalid Request"]);
        case 401:
        case 403:
          throw Exception(["Unauthorized Request"]);
        default:
          throw Exception(["An error occured ${request.statusCode}"]);
      }
    } on TimeoutException catch (timeoutErr) {
      throw Exception(["Network Timeout"]);
    }
  }
}
