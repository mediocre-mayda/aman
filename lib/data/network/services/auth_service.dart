import 'dart:convert';

import 'package:aman/data/repositories/aman_repository.dart';

class AuthService {
  Repository _repository;

  AuthService() {
    _repository = Repository();
  }

  login(String email, String password) async {
    Map<String, String> body = {};
    body['username'] = email;
    body['password'] = password;
    return _repository
        .httpPost("user/signin", body: json.encode(body));
  }
}
