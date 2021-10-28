import 'package:flutter/material.dart';

class OptionWidgett extends StatelessWidget {
  const OptionWidgett({
    @required this.text,
    @required this.isTrue,
  });
  final String? text;
  final bool? isTrue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            title: Text(
              "$text",
              style: TextStyle(fontSize: 16),
            ),
            trailing: Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                color: isTrue == true ? Colors.green : Colors.red,
                border: Border.all(),
                borderRadius: BorderRadius.circular(50),
              ),
              child: isTrue == true
                  ? Icon(
                      Icons.done,
                      size: 16,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
            ),
          )),
    );
  }
}
