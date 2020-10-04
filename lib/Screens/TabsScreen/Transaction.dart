import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Data/Transaction.dart';
import '../../Networking/Transactions.dart';
import '../../constants.dart';

import '../../Rounded_Button.dart';

class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            bottom: TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'Transfer Money'),
                Tab(
                  text: 'History',
                ),
              ],
            ),
            title: Text(
              'Transactions',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: TabBarView(
            children: [
              TransferScreen(),
              HistoryScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

class TransferScreen extends StatefulWidget {
  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  Transaction transaction = Transaction();
  bool isExpanded = false;
  String accountNo;
  String name;
  double amount;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  int presentAmount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAmount();
  }

  @override
  Widget build(BuildContext context) {
    void _saveform() async {
      final isValid = _formKey.currentState.validate();
      if (isValid) {
        setState(() {
          isLoading = true;
        });

        _formKey.currentState.save();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Please wait....'),
        ));
        await Transactions().changeAmount(transaction.amount);
        await Transactions().transfer(transaction).then((value) async {
          setState(() {
            isLoading = false;
          });

          if (value == 200) {
            _scaffoldKey.currentState.showSnackBar(
                SnackBar(content: Text('Transaction Complete your id $value')));
          }
        });
      } else {
        return;
      }
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            key: _scaffoldKey,
            body: Center(
                child: Column(children: <Widget>[
              Container(
                //   color: Color(0xFFEF4935),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'Transfer Money',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w300),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Button(
                            text: 'Transfer Now',
                            tag: 'Pay',
                            onPressed: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (isExpanded)
                            Container(
                                decoration: kContainerdecoration,
                                height: 300,
                                child: Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: ListView(
                                      children: <Widget>[
                                        TextFormField(
                                          textAlign: TextAlign.center,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Enter account no';
                                            } else if (value.length < 9) {
                                              return 'Enter valid account No';
                                            } else {
                                              return null;
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration:
                                              ktextfieldDecoration.copyWith(
                                                  hintText: 'Enter account No'),
                                          onChanged: (value) {
                                            transaction.accountNo = value;
                                          },
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        TextFormField(
                                          textAlign: TextAlign.center,
                                          decoration: ktextfieldDecoration.copyWith(
                                              hintText:
                                                  'Enter account holder\'s name'),
                                          onChanged: (value) {
                                            transaction.name = value;
                                          },
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return 'Enter account holder\'s name';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        TextFormField(
                                          textAlign: TextAlign.center,
                                          validator: (value) {
                                            print(presentAmount);

                                            if (value.isEmpty) {
                                              return 'Enter amount less than present in your wallet';
                                            } else if (num.parse(value) >
                                                presentAmount) {
                                              return 'Your amount exceeds the present amount in your wallet';
                                            } else {
                                              return null;
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: ktextfieldDecoration.copyWith(
                                              hintText:
                                                  'Enter amount to be transferred'),
                                          onChanged: (value) {
                                            transaction.amount = value;
                                          },
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        isLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : Button(
                                                text: 'Pay Now',
                                                tag: 'one',
                                                onPressed: () {
                                                  _saveform();
                                                },
                                              )
                                      ],
                                    ),
                                  ),
                                )),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]))));
  }

  void getAmount() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      presentAmount = prefs.getInt('amountPresent');
    });
    print('set state ke baaad $presentAmount');
  }
}

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
              Container(
                //   color: Color(0xFFEF4935),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'List of Transactions',
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 25),
                      ),
                    ),
                  ],
                ),
              )
            ]))));
  }

  void getTransaction() async {
    await Transactions().getTransactions();
  }
}
