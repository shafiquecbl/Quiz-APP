import 'package:flutter/material.dart';
import 'package:quiz_app/size_config.dart';

// ignore: must_be_immutable
class SearchField extends StatefulWidget {
  String? search, hintText;
  SearchField({@required this.search, @required this.hintText});

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth! / 4.2,
      height: 45,
      child: TextFormField(
        onSaved: (value) {
          setState(() {
            widget.search = value;
          });
        },
        onChanged: (value) {
          setState(() {
            widget.search = value;
          });
        },
        onFieldSubmitted: (value) {
          setState(() {
            widget.search = value;
          });
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: 14),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
