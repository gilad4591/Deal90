import 'dart:convert';

import 'package:http/http.dart' as http;

class SendPush {
  static String baseUrl = "https://fcm.googleapis.com/fcm";

  static Future<http.Response> to(String to, {String title, String body, String imageUrl}) async{
    return http.post(
      '$baseUrl/send',
      headers: {
        'Content-Type': 'application/json',
        "Authorization":
            "key=AAAAXCI0IYk:APA91bEhpD2rwIaagLlZz2NnORNw-wJ0Z40MVVtFbrvQWwhCqB119jXJ2LKsFxhjJ2S4CBYGdDC9foeqiHGIXKnQyXHwx8STybC5kqJU--codZrCsAmRhsYEu_hdUdDxZhkvzDC-jVFX"
      },
      body: jsonEncode({
        "to": to,
        "data":{
          "title" : title,
          "body" : body,
          //"image": imageUrl,
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        }
      })
    );

  }
}
