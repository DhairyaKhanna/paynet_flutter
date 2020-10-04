import 'dart:convert';

import 'package:http/http.dart' as http;
import '../Data/Transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Transactions {
  List<String> transId = [];

  Future<dynamic> transfer(Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('amountDataKey');
    try {
      var response = await http.post(
          'https://restapi-7c8ab.firebaseio.com/$id/transactions.json',
          body: json.encode({
            'accountNo': transaction.accountNo,
            'name': transaction.name,
            'amount': transaction.amount
          }));
      print(response.statusCode);
      print(response.body);

      transId.add(json.decode(response.body)['name']);
      print(transId[1]);

      var data = json.decode(response.body)['name'];
      if (response.statusCode == 200) {
        print(transId.length);
        return data;
      } else {
        print('error');
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
    print(transId.length);
  }

  Future<dynamic> getAmount() async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('amountDataKey');
    print(data);

    var response = await http.get(
        'https://restapi-7c8ab.firebaseio.com/amountBalance/$data/amountBalance.json');

    print('this is body of response${response.body}');
    print(response.statusCode);
    print(response.statusCode);
    return response.body;

    if (response.statusCode == 200 | 202) {
      return response.body;
    }
  }

  Future<dynamic> changeAmount(var debitedAmount) async {
    final prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('amountDataKey');
    var presentAmount = prefs.getInt('amountPresent');
    print(data);
    print('present amount $presentAmount');
    print(presentAmount - num.parse(debitedAmount));
    try {
      var response = await http.patch(
          'https://restapi-7c8ab.firebaseio.com/amountBalance/$data.json',
          body: json.encode({
            "amountBalance": presentAmount - num.parse(debitedAmount),
          }));

      print('this is from put request${response.body}');
      print('this is status code${response.statusCode}');
      if (response.statusCode == 200) {
        return response.statusCode;
      }
    } catch (e) {}
  }

  Future<dynamic> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('amountDataKey');
    List<http.Response> responses = [];

    for (int i = 0; i < transId.length; i++) {
      var response = await http.get(
          'https://restapi-7c8ab.firebaseio.com/$id/transactions/${transId[i]}.json');
      responses.add(response);
      print(response.body);
    }

    Map<String, dynamic> transactionData = {
      "transactionIdLength": transId.length,
      "transactionData": responses
    };

    print(transactionData.values);
    return transactionData;
  }
}
