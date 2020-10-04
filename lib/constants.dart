import 'package:flutter/material.dart';

const ktextfieldDecoration = InputDecoration(
  hintText: 'Enter your Email',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const List<String> buttons = [
  'Account Information',
  'Check Balance',
  'Transfer Money',
  'Transaction History',
  'LogOut'
];

const ktextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

const kContainerdecoration = BoxDecoration(boxShadow: [
  BoxShadow(
      color: Colors.blueGrey,
      blurRadius: 40,
      spreadRadius: 10,
      offset: Offset(2.0, 2.0))
], color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20)));

const kText = TextStyle(
    color: Colors.white, fontSize: 22, decoration: TextDecoration.underline);

const List<String> heroes = [
  'PaYNET1',
  'PaYNET2',
  'PaYNET3',
  'PaYNET4',
  'PaYNET5',
];
