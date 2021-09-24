import 'package:flutter/material.dart';

class OptionWidget extends StatelessWidget {
  const OptionWidget(
      {@required this.text,
      @required this.onPressed,
      @required this.isSelected,
      @required this.index});
  final String? text;
  final int? index;
  final Function()? onPressed;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: InkWell(
        onTap: onPressed,
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
              leading: Text(
                '$index. ',
                style: TextStyle(fontSize: 16),
              ),
              title: Text(
                "$text",
                style: TextStyle(fontSize: 16),
              ),
              trailing: Container(
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                  color: isSelected == true ? Colors.green : Colors.white,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: isSelected == true
                    ? Icon(
                        Icons.done,
                        size: 16,
                        color: Colors.white,
                      )
                    : Container(),
              ),
            )),
      ),
    );
  }
}
