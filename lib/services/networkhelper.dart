import 'package:http/http.dart' as http;
import 'dart:convert';

class NetWorkHelper {
  NetWorkHelper(this.url);
  final Uri url;

  Future getData() async {
    http.Response response =
        await http.get(url, headers: {'Accept': 'application/json'});
    if (response.statusCode == 200) {
      String data = response.body;
      return json.decode(data);
    } else {
      print(response.statusCode);
    }
  }
}