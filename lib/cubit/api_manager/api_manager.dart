import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mattar/module/timer.dart';

class ApiManager {
  static const String baseurl = 'admin.rain-app.com';

  static Future<TimerCount> getTimer(String countryID, String userId) async {
    var url =
        Uri.https(baseurl, '/api/subscribe-via-ad', {'country': countryID});

    var response = await http.post(url);
    return TimerCount.fromJson(jsonDecode(response.body));
  }
}
