import 'package:flutter/material.dart';
import 'package:quiz_app/Models/Student/Quiz.dart';
import 'package:quiz_app/Screens/STUDENT/QuizPage/components/option.dart';

import '../../../../constants.dart';

class QuizBody extends StatefulWidget {
  final Question1? question;
  const QuizBody({@required this.question});

  @override
  _QuizBodyState createState() => _QuizBodyState();
}

class _QuizBodyState extends State<QuizBody> {
  ScrollController controller = ScrollController();
  bool? option1 = false;
  bool? option2 = false;
  bool? option3 = false;
  bool? option4 = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Scrollbar(
      isAlwaysShown: true,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: Scrollbar(
                      controller: controller,
                      isAlwaysShown: true,
                      interactive: true,
                      showTrackOnHover: true,
                      child: SingleChildScrollView(child: header()))),
            ),

            //////////////////////////////////////////////////////

            SizedBox(
              height: 10,
            ),

            //////////////////////////////////////////////////////

            OptionWidget(
                text: widget.question!.options![0].options1,
                index: 1,
                onPressed: () {
                  setState(() {
                    option1 = true;
                    option2 = false;
                    option3 = false;
                    option4 = false;
                  });
                },
                isSelected: option1),
            OptionWidget(
                text: widget.question!.options![0].options2,
                index: 2,
                onPressed: () {
                  setState(() {
                    option1 = false;
                    option2 = true;
                    option3 = false;
                    option4 = false;
                  });
                },
                isSelected: option2),
            OptionWidget(
                text: widget.question!.options![0].options3,
                index: 3,
                onPressed: () {
                  setState(() {
                    option1 = false;
                    option2 = false;
                    option3 = true;
                    option4 = false;
                  });
                },
                isSelected: option3),
            OptionWidget(
                text: widget.question!.options![0].options4,
                index: 4,
                onPressed: () {
                  setState(() {
                    option1 = false;
                    option2 = false;
                    option3 = false;
                    option4 = true;
                  });
                },
                isSelected: option4)
          ],
        ),
      ),
    ));
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(
          widget.question!.questionStatement.toString(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
