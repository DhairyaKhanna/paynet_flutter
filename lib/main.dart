import 'package:flutter/material.dart';
import 'Screens/TabsScreen/HomeScreen.dart';
import 'Screens/Registration/LogIn.dart';
import 'Screens/Registration/Registration.dart';
import 'Screens/Registration/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Auth_Screen(),
      routes: {
        Auth_Screen.id: (context) => Auth_Screen(),
        LogInScreen.id: (context) => LogInScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        TabsDemoScreen.id: (context) => TabsDemoScreen()
      },
    );
  }
}
