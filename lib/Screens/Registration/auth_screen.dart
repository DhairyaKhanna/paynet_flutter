import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';
import '../../Networking/LogIn.dart';
import '../../Networking/otp_verify.dart';
import '../TabsScreen/HomeScreen.dart';

import '../../Networking/otp_verify.dart';
import '../../Rounded_Button.dart';
import '../../constants.dart';
import 'otpScreen.dart';

enum AuthMode { SignIn, Login }

class Auth_Screen extends StatefulWidget {
  static const String id = 'Welcome_screen';

  @override
  _Auth_ScreenState createState() => _Auth_ScreenState();
}

class _Auth_ScreenState extends State<Auth_Screen>
    with SingleTickerProviderStateMixin {
  String phone;
  String password;
  AuthMode _authmode;
  bool isLoading = false;
  AnimationController controller;
  Animation animation;
  final _scaffoldKeyy = GlobalKey<ScaffoldState>();

  LogIn login = LogIn();

  @override
  void initState() {
    _authmode = AuthMode.SignIn;
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = ColorTween(begin: Colors.lightGreen, end: Colors.limeAccent)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    if (number == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Enter your full number'),
        duration: Duration(seconds: 2),
      ));
    } else {
      setState(() {
        phone = number;
      });
    }
  }

  void SignIn() async {
    setState(() {
      isLoading = true;
    });
    await networking.otpsent(phone).then((response) {
      setState(() {
        isLoading = false;
      });
      if (response == 200) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                OtpScreen(phoneNumber: phone, authMode: 'SignIn')));
      } else {
        _scaffoldKeyy.currentState.showSnackBar(SnackBar(
          content: Text(
            response,
            style: TextStyle(fontSize: 15),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
      }
    });
  }

  void logIn() async {
    setState(() {
      isLoading = true;
    });
    print(phone);
    print(password);
    await login.login(phone, password).then((value) {
      setState(() {
        isLoading = false;
      });
      print('$value value');
      if (value == 202) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => TabsDemoScreen()));
      } else {
        setState(() {
          isLoading = false;
        });
        _scaffoldKeyy.currentState.showSnackBar(SnackBar(
          content: Text(
            '$value Error try again',
            style: TextStyle(fontSize: 15),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
      }
    });
  }

  String buttonText() {
    if (_authmode == AuthMode.Login)
      return 'Sign In';
    else if (_authmode == AuthMode.SignIn) return 'Sign Up';
  }

  String textBottom() {
    if (_authmode == AuthMode.SignIn)
      return 'Have an account Already ? Sign In';
    else
      return 'Go back';
  }

  void _switchAuthMode() {
    if (_authmode == AuthMode.SignIn) {
      setState(() {
        _authmode = AuthMode.Login;
      });
    } else if (_authmode == AuthMode.Login) {
      setState(() {
        _authmode = AuthMode.SignIn;
        print(_authmode);
      });
    }
  }

  Networking networking = Networking();

  bool flag = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyy,
      backgroundColor: animation.value,
      body: ListView(
        children: <Widget>[
          Hero(
            tag: 'PayNet',
            child: Container(
              child: Image.asset('images/logo.png'),
              height: 100.0,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Center(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                margin: EdgeInsets.only(top: 40),
                width: 300,
                decoration: kContainerdecoration,
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Your Phone!',
                        style: ktextStyle,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Phone Number',
                        style: ktextStyle,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: InternationalPhoneInput(
                            decoration:
                                InputDecoration(hintText: 'Enter Phone No'),
                            onPhoneNumberChange: onPhoneNumberChange,
                            initialPhoneNumber: phone,
                            initialSelection: 'US',
                            enabledCountries: ['+91'],
                            showCountryCodes: true),
                      ),
                      if (_authmode == AuthMode.Login && flag == false)
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            obscureText: true,
                            onChanged: (value) {
                              password = value;
                            },
                            decoration: InputDecoration(labelText: 'Password'),
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: isLoading
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.greenAccent,
                                  )
                                : Button(
                                    tag: 'Paynet',
                                    text: buttonText(),
                                    onPressed: () {
                                      if (_authmode == AuthMode.SignIn) {
                                        SignIn();
                                      } else {
                                        logIn();
                                      }
                                    }),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Center(
              child: SelectableText(
                textBottom(),
                onTap: () {
                  if (textBottom() == 'Have an account Already ? Sign In') {
                    _switchAuthMode();
                  } else if (textBottom() == 'Go back') {
                    print(_authmode);
                    _switchAuthMode();
                  }
                },
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
