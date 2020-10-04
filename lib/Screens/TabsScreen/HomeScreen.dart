import 'package:flutter/material.dart';
import 'Transaction.dart';
import 'profile.dart';
import 'Balance.dart';

class TabsDemoScreen extends StatefulWidget {
  static final id = 'Tabs';
  @override
  _TabsDemoScreenState createState() => _TabsDemoScreenState();
}

class _TabsDemoScreenState extends State<TabsDemoScreen> {
  List<Widget> tabs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabs = [TransactionScreen(), Balance(), ProfileScreen()];
  }

  int currentTabIndex = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: tabs[currentTabIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightGreen,
        onTap: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: currentTabIndex == 0 ? 30 : 20,
            ),
            title: Text(
              "Wallet",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance,
              color: Colors.white,
              size: currentTabIndex == 1 ? 30 : 20,
            ),
            title: Text(
              "Balance",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: Colors.white,
              size: currentTabIndex == 2 ? 30 : 20,
            ),
            title: Text(
              "Account",
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
