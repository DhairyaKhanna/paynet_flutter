import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../Rounded_Button.dart';
import '../../constants.dart';

class LogInScreen extends StatefulWidget {
  static const String id = 'LoginScreen';

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  String phone;
  String pin;
  bool showSpinner = false;

  TextEditingController pinT = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              Form(
                  child: Column(
                children: <Widget>[
                  TextFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Enter your registered phone number';
                      } else if (value.length < 10) {
                        return 'Enter correct phone number';
                      } else {
                        return null;
                      }
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      phone = value;
                    },
                    decoration: ktextfieldDecoration.copyWith(
                      hintText: 'Enter your phone number',
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextFormField(
                    controller: pinT,
                    validator: (value) {
                      if (value == null) {
                        return 'Enter your password';
                      } else if (value.length < 6) {
                        return 'Enter correct password';
                      } else {
                        return null;
                      }
                    },
                    textAlign: TextAlign.center,
                    obscureText: true,
                    onChanged: (value) {
                      pin = value;
                    },
                    decoration: ktextfieldDecoration.copyWith(
                        hintText: 'Enter your PIN'),
                  ),
                ],
              )),
              SizedBox(
                height: 24.0,
              ),
              Button(
                tag: 'login',
                text: 'Log In',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                },
                color: Colors.lightBlueAccent,
              )
            ],
          ),
        ),
      ),
    );
  }
}
