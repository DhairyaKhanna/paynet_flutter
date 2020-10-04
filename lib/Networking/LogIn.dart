import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Data/User.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const url = "http://seriunited.herokuapp.com/api/";
const amountBalance = 'https://restapi-7c8ab.firebaseio.com/amountBalance.json';

enum Status { Authenticated, Authenticating, Unauthenticated }

class LogIn extends ChangeNotifier {
  String phoneNo;
  String password;
  String token;

  Future<dynamic> login(String phoneNo, String password) async {
    try {
      var response = await http.post("${url}vendor/login/",
          headers: {'Content-Type': 'application/json'},
          body: json.encode({"phone_number": phoneNo, "password": password}));

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(response.body);

      if (response.statusCode == 200 | 202) {
        token = extractedData['token'];
        getAndSaveToken(token);
        return response.statusCode;
      } else {
        print(response.statusCode);
        return extractedData['error'];
      }
    } catch (error) {
      throw error;
    }
  }

  getAndSaveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Token', token);
  }

  deleteUserToken() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    print('token deleted');
  }

  Future<dynamic> registerUser(NewUser userData) async {
    var userDetails = await http.post('${url}vendor/registeration/',
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "phone_number": userData.phoneNumber,
          "email": userData.email,
          "first_name": userData.name,
          "last_name": '_',
          "password": userData.pin,
          "company_name": '_',
          "type_of_vendor": '_'
        }));

    final extractedData = json.decode(userDetails.body) as Map<String, dynamic>;

    List<String> userDataInfo = [
      extractedData['token'],
      userData.phoneNumber,
      userData.name,
      userData.email,
      userData.dob,
      userData.logInTime
    ];

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('UserInfo', userDataInfo);

    token = extractedData['token'];
    LogIn().getAndSaveToken(token);
    if (userDetails.statusCode == 202) {
      print(userDetails.statusCode);
      return userDetails.statusCode;
    } else if (userDetails.statusCode == 400) {
      return extractedData['non_field_errors'];
    } else {
      print(userDetails.statusCode);
      return extractedData['non_field_errors'];
    }
  }

  Future<dynamic> logOut() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('Token');
    var authToken = 'Token' + ' ' + token;
    try {
      var response = await http.post("${url}logout/", headers: {
        'Content-Type': 'application/json',
        'Authorization': authToken
      });
      deleteUserToken();

      print(response.body);
      return response.statusCode;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<dynamic> amount() async {
    var amount = await http.post(amountBalance,
        body: json.encode({"amountBalance": 1000}));
    final amountData = json.decode(amount.body) as Map<String, dynamic>;
    final prefsA = await SharedPreferences.getInstance();
    print(amountData['name']);
    print(amount.body);
    prefsA.setString('amountDataKey', amountData['name']);
  }
}
