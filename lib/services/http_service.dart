import 'package:example_app/models/earthquake_model.dart';

import 'package:http/http.dart' as http;

class HttpService {
  static Future<Earthquake> getData() async {
    final response = await http.get(
        Uri.parse('https://api.orhanaydogdu.com.tr/deprem/live.php?limit=25'));
    if (response.statusCode == 200) {
      return earthquakeFromJson(response.body);
    } else {
      throw Exception("Failed");
    }
  }
}
