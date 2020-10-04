import 'package:flutter/material.dart';
import 'package:paynet_flutter/Networking/LogIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Networking/Transactions.dart';
import '../../constants.dart';

class Balance extends StatefulWidget {
  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  String amount = '0';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Balance',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: Text(
              'Account in your wallet',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: kContainerdecoration,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                  ),
                  Text(
                    'Amount present in your wallet is : $amount',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> getBalance() async {
    await LogIn().amount();
    String newAmount = await Transactions().getAmount();
    setState(() {
      amount = newAmount;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('amountPresent', num.parse(amount));
    return amount;
  }
}
