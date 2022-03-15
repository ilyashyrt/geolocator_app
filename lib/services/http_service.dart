

import 'package:example_app/constants/strings.dart';
import 'package:example_app/models/earthquake_model.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static Future<Earthquake> getData() async {
    final response = await http.get(Uri.parse(AppStrings.baseUrl));
    if (response.statusCode == 200) {
      return earthquakeFromJson(response.body);
    } else {
      throw Exception(AppStrings.errorText);
    }
  }
}
