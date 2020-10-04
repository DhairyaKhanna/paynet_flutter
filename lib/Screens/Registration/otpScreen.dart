import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Networking/otp_verify.dart';
import 'Registration.dart';
import '../../Rounded_Button.dart';
import '../../constants.dart';
import 'auth_screen.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({this.phoneNumber, this.authMode});
  final String phoneNumber;
  final String authMode;

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Networking network = Networking();

  String otp;

  String password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  void otpChoice() async {
    if (widget.authMode == 'SignIn') {
      setState(() {
        isLoading = true;
      });
      await network
          .otpVerification(widget.phoneNumber, otp)
          .then((responseCode) {
        setState(() {
          isLoading = false;
        });
        if (responseCode == 200) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return RegistrationScreen();
          }));
        } else {
          print(responseCode);
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              responseCode,
              style: TextStyle(fontSize: 15),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'Paynet',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 100.0,
                  ),
                ),
                Container(
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
                          'OTP Verification',
                          style: ktextStyle,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Enter the OTP you received to',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '+91 ${widget.phoneNumber}',
                          style: ktextStyle,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  otp = value;
                                  print(otp);
                                },
                                decoration: InputDecoration(
                                    hintText: 'Enter Otp You received'),
                              ),
                            ),
                            if (widget.authMode == 'PasswordChange')
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {
                                    password = value;
                                  },
                                  decoration: InputDecoration(
                                      hintText: 'Enter Your New Password'),
                                ),
                              ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                isLoading
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.greenAccent,
                      )
                    : Button(
                        tag: 'PayNet', text: 'Continue', onPressed: otpChoice)
              ],
            ),
          );
        }));
  }
}
