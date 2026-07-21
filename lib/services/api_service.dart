import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart'
    as http;

class ApiService {

  static const String baseUrl =
    "http://192.168.0.177:8000";

  static Future<Map<String, dynamic>>
      predictDisease(
          File imageFile) async {

    var request =
        http.MultipartRequest(
      "POST",
      Uri.parse(
        "$baseUrl/predict",
      ),
    );

    request.files.add(
      await http.MultipartFile
          .fromPath(
        "file",
        imageFile.path,
      ),
    );

    var response =
        await request.send();

    var responseBody =
        await response.stream
            .bytesToString();

    return jsonDecode(
      responseBody,
    );
  }
}