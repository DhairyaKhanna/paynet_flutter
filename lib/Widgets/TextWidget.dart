import 'package:flutter/material.dart';

class NewText extends StatelessWidget {
  NewText(this.controllerT);

  final TextEditingController controllerT;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
        TextField(
          controller: controllerT,
        ),
      ],
    );
  }
}
