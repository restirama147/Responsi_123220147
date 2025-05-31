import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:responsi_123220147/model/phone_model.dart';


class PhoneService {
  static const url = 'https://tpm-api-responsi-e-f-872136705893.us-central1.run.app/api/v1/phones';

  static Future<Map<String, dynamic>> getPhone() async {
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getPhoneById(int id) async {
    final response = await http.get(Uri.parse("$url/$id"));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createPhone(Phone newPhone) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newPhone)
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updatePhone(Phone updatedPhone) async {
    final response = await http.put(
      Uri.parse("$url/${updatedPhone.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedPhone.toJson())
    );
    return jsonDecode(response.body);
  }
  
  static Future<Map<String, dynamic>> deletePhone(int id) async {
    final response = await http.delete(
      Uri.parse("$url/$id"),
    );
    return jsonDecode(response.body);
  }
}
