import 'package:http/http.dart' as http;

class Repository {
  String _baseUrl = 'https://aman-ly.herokuapp.com/api';
  //String _baseUrl = 'http://elsahly2020-001-site1.btempurl.com';
  String get baseUrl => _baseUrl;
  var headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  httpGet(String api) async {
    return http.get(_baseUrl + "/" + api, headers: headers);
  }

  httpPost(String api, {String body}) async {
    return http.post(_baseUrl +"/" + api, body: body , headers: headers);
  }

  // httpGetNewBaseUrl(String api) async {
  //   return http.get(_newBaseUrl + "/" + api);
  // }
}
