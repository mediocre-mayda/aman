import 'dart:convert';

import 'package:aman/data/repositories/aman_repository.dart';

class ReportService {
  Repository _repository;

  ReportService() {
    _repository = Repository();
  }

  postReport(
      String type, String description, String token, String userId) async {
    Map<String, String> body = {};
    body['reportType'] = type;
    body['userId'] = userId;
    body['message'] = description;
    body['lat'] = "32";
    body['long'] = "22";

    Map<String, String> headers = {};
    headers['Authorization'] = "Bearer " + token;

    return _repository.httpPostWithHeaders("/reports",
        body: json.encode(body), newHeaders: headers);
  }
}
