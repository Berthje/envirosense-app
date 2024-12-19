import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ApiResponse {
  final dynamic data;
  final Map<String, String> headers;

  ApiResponse(this.data, this.headers);
}

class ApiService {
  final String baseUrl = dotenv.env['API_BASE_URL']!;
  final String? _token = dotenv.env['API_TOKEN'];

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Accept-Encoding': 'gzip, deflate, br',
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      };

  Future<dynamic> getRequest(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('GET request failed with status: ${response.statusCode}');
    }
  }

  Future<ApiResponse> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
      body: jsonEncode(body),
    );
    print('$baseUrl/$endpoint');
    print("response headers ${response.headers}");
    print("response body ${response.body}");

    return ApiResponse(jsonDecode(response.body), response.headers);
  }
}
