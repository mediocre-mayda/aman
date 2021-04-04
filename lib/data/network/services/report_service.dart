import 'dart:convert';

import 'package:aman/data/repositories/aman_repository.dart';

class ReportService {
  Repository _repository;

  ReportService() {
    _repository = Repository();
  }

  postReport(
      String type, String description, String token, String userId, double lat, double lng) async {
    Map<String, dynamic> body = {};
    body['reportType'] = type;
    body['userId'] = userId;
    body['message'] = description;
    body['lat'] = lat;
    body['long'] = lng;

    Map<String, String> headers = {};
    headers['Authorization'] = "Bearer " + token;

    return _repository.httpPostWithHeaders("/reports",
        body: json.encode(body), newHeaders: headers);
  }
}
