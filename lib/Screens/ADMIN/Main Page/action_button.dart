import 'package:flutter/material.dart';
import 'package:quiz_app/constants.dart';

class ActionButton extends StatefulWidget {
  final String? text;
  final Function()? onPressed;
  const ActionButton({@required this.text, @required this.onPressed});

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: yellow.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextButton(
          onPressed: widget.onPressed,
          child: Center(
            child: Text(
              widget.text.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )),
    );
  }
}
