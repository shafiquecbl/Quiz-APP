import 'package:flutter/material.dart';
import 'package:quiz_app/constants.dart';

class HeadCard extends StatefulWidget {
  final Function()? onPressed;
  final String? title;
  const HeadCard({@required this.title, @required this.onPressed});

  @override
  _HeadCardState createState() => _HeadCardState();
}

class _HeadCardState extends State<HeadCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Card(
          color: yellow,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Text(widget.title.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: whiteColor)),
                Spacer(),
                Container(
                  height: 40,
                  width: 100,
                  child: ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.grey[500]),
                      onPressed: widget.onPressed,
                      icon: Icon(Icons.add),
                      label: Text('ADD  ')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
