import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController account = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController age = TextEditingController();
  String time;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Information'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextField(
              controller: account,
              textAlign: TextAlign.center,
              decoration: ktextfieldDecoration.copyWith(
                  hintText: 'Your auto generated account No'),
            ),
            TextField(
              controller: number,
              textAlign: TextAlign.center,
              decoration:
                  ktextfieldDecoration.copyWith(hintText: 'Your phone Number'),
            ),
            TextField(
              controller: name,
              textAlign: TextAlign.center,
              decoration: ktextfieldDecoration.copyWith(hintText: 'Your name'),
            ),
            TextField(
              controller: email,
              textAlign: TextAlign.center,
              decoration:
                  ktextfieldDecoration.copyWith(hintText: 'Your email account'),
            ),
            TextField(
              controller: age,
              textAlign: TextAlign.center,
              decoration:
                  ktextfieldDecoration.copyWith(hintText: 'Your date of birth'),
            ),
            Card(
              elevation: 10,
              child: ListTile(
                title: Text('Last login'),
                trailing: Text('Time of last login $time'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data = prefs.getStringList('UserInfo');

    String agee = prefs.getString('age');
    print(data);
    if (data != null) {
      account.text = data[0];
      number.text = data[1];
      name.text = data[2];
      email.text = data[3];
      time = data[4];
      age.text = agee;
    } else {
      account.text = null;
      number.text = null;
      name.text = null;
      email.text = null;
      time = null;
      age.text = null;
    }
  }
}
