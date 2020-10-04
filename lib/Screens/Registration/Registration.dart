import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../Data/User.dart';
import '../../Networking/LogIn.dart';
import '../TabsScreen/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Rounded_Button.dart';
import '../../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static final id = 'Registration';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _name = FocusNode();
  final _email = FocusNode();
  final _mobileNo = FocusNode();
  final _pin = FocusNode();
  final _dob = FocusNode();
  final _check = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  DateTime date;
  TextEditingController dob = TextEditingController();
  TextEditingController age = TextEditingController();
  NewUser user = NewUser();
  int selectedValue = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mobileNo.dispose();
    _pin.dispose();
    _dob.dispose();
    age.clear();
    _check.dispose();
    _email.dispose();
    _name.dispose();
    dob.clear();
  }

  @override
  Widget build(BuildContext context) {
    void _saveForm() async {
      final isValid = _formKey.currentState.validate();
      if (isValid) {
        setState(() {
          isLoading = true;
        });

        _formKey.currentState.save();
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Please wait....'),
        ));
        await LogIn().registerUser(user).then((response) {
          setState(() {
            isLoading = true;
          });
          if (response == 200 | 202) {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TabsDemoScreen()));
          } else {
            _scaffoldKey.currentState.showSnackBar(
                SnackBar(content: Text('$response Error try again....')));
          }
        });
      } else {
        return;
      }
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: ListView(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 150.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            if (value == null) {
                              return 'Enter your name';
                            } else {
                              return null;
                            }
                          },
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            user.name = value;
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(_email);
                          },
                          decoration: ktextfieldDecoration.copyWith(
                            hintText: 'Enter your name',
                          ),
                          focusNode: _name,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          focusNode: _email,
                          validator: (value) {
                            if (value == null) {
                              return 'Enter your email';
                            } else if (!value.contains('.com')) {
                              return 'Enter correct email address';
                            } else if (!value.contains('@')) {
                              return 'Enter correct email address';
                            } else {
                              return null;
                            }
                          },
                          textAlign: TextAlign.center,
                          obscureText: false,
                          onChanged: (value) {
                            user.email = value;
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(_mobileNo);
                          },
                          decoration: ktextfieldDecoration.copyWith(
                              hintText: 'Enter your Email'),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          focusNode: _mobileNo,
                          validator: (value) {
                            if (value == null) {
                              return 'Enter mobile';
                            } else if (value.length != 10) {
                              return 'Enter valid mobile no';
                            } else {
                              return null;
                            }
                          },
                          textAlign: TextAlign.center,
                          obscureText: false,
                          onChanged: (value) {
                            user.phoneNumber = value;
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(_pin);
                          },
                          decoration: ktextfieldDecoration.copyWith(
                              hintText: 'Enter your mobile number'),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          focusNode: _pin,
                          validator: (value) {
                            if (value == null) {
                              return 'Enter pin';
                            } else if (value.length < 6) {
                              return 'PIN length should be greater than 6';
                            } else {
                              return null;
                            }
                          },
                          textAlign: TextAlign.center,
                          obscureText: true,
                          onChanged: (value) {
                            user.pin = value;
                          },
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(_dob);
                          },
                          decoration: ktextfieldDecoration.copyWith(
                              hintText: 'Enter your PIN'),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextFormField(
                          controller: dob,
                          focusNode: _dob,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(_check);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Enter your date of birth';
                            } else {
                              return null;
                            }
                          },
                          textAlign: TextAlign.center,
                          obscureText: false,
                          decoration: ktextfieldDecoration.copyWith(
                              suffix: IconButton(
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  onPressed: () async {
                                    date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1940),
                                        lastDate: DateTime.now());
                                    dob.text =
                                        '${date.year.toString()}-${date.month < 10 ? '0' + date.month.toString() : date.month.toString()}-${date.day < 10 ? '0' + date.day.toString() : date.day.toString()}'
                                            .toString();
                                    user.dob = dob.text;
                                    user.logInTime = TimeOfDay.now().toString();
                                    print(user.logInTime);
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('age',
                                        '${DateTime.now().year - date.year}');
                                    print(prefs.getString('age'));
                                    if (DateTime.now().year - date.year < 7) {
                                      age.text = '<7';
                                    } else if (DateTime.now().year -
                                                date.year <=
                                            12 &&
                                        DateTime.now().year - date.year >= 7) {
                                      age.text = '7-12';
                                    } else if (DateTime.now().year -
                                                date.year <=
                                            18 &&
                                        DateTime.now().year - date.year >= 13) {
                                      age.text = '13-18';
                                    } else if (DateTime.now().year - date.year >
                                        18) {
                                      age.text = '18+';
                                    }
                                  }),
                              hintText:
                                  'Enter your date of birth (YYYY/MM/DD)'),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: age,
                  textAlign: TextAlign.center,
                  decoration: ktextfieldDecoration.copyWith(hintText: 'Age'),
                ),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Button(
                        tag: 'register',
                        text: 'Register',
                        onPressed: () {
                          _saveForm();
                        },
                        color: Colors.lightBlueAccent,
                      )
              ],
            ),
          ),
        ));
  }
}
