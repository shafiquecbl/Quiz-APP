import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/constants.dart';

class CustomCard extends StatelessWidget {
  final Function()? onPressed;
  final String? courseName;
  const CustomCard({@required this.onPressed, @required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: yellow,
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(1, 0),
          )
        ], color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
        child: TextButton(
          style: ButtonStyle(
              // overlayColor: MaterialStateColor.resolveWith((states) => yellow),
              ),
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.book_outlined,
                color: yellow,
                size: 42,
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                courseName.toString(),
                style: GoogleFonts.teko(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87.withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
