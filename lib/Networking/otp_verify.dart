import 'package:http/http.dart' as http;
import 'dart:convert';

const url = "http://seriunited.herokuapp.com/api/vendor/";

class Networking {
  Future<dynamic> otpsent(String phoneNumber) async {
    var answeredResponse = await http.post('${url}request-otp/',
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"phone_number": phoneNumber}));
    print(answeredResponse.statusCode);
    if (answeredResponse.statusCode == 200) {
      return answeredResponse.statusCode;
    } else {
      final extractedData =
          json.decode(answeredResponse.body) as Map<String, dynamic>;
      return extractedData['error'];
    }
  }

  Future<dynamic> otpVerification(String phoneNumber, String otp) async {
    var answeredResponse = await http.post("${url}verify-otp/",
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({"phone_number": phoneNumber, "otp_code": otp}));

    print(answeredResponse.statusCode);
    print(answeredResponse.body);
    if (answeredResponse.statusCode == 200) {
      print(answeredResponse.body);
      return answeredResponse.statusCode;
    } else {
      final extractedData =
          json.decode(answeredResponse.body) as Map<String, dynamic>;
      return extractedData['error'];
    }
  }

  Future<dynamic> changePassword(String phoneNumber) async {
    try {
      var answeredResponse = await http.post('${url}password-reset-sms/',
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({"phone_number": phoneNumber}));
      print(answeredResponse.statusCode);
      print('change password request');
      if (answeredResponse.statusCode == 200) {
        return answeredResponse.statusCode;
      } else {
        print('backend error');
        return json.decode(answeredResponse.body)['errors'];
      }
    } catch (e) {
      throw e;
    }
  }
}
