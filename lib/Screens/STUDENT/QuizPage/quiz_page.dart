import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:quiz_app/Models/Student/Quiz.dart';

import 'components/quiz_body.dart';

class QuizPage extends StatefulWidget {
  final Quiz1? quiz;
  const QuizPage({@required this.quiz});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 9, right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NumberStepper(
              numbers: List.generate(
                  widget.quiz!.question!.length, (index) => index + 1),
              activeStep: activeStep,
              onStepReached: (index) {
                setState(() {
                  activeStep = index;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            QuizBody(
              question: widget.quiz!.question![activeStep],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                activeStep == 0 ? Container() : previousButton(),
                activeStep == widget.quiz!.question!.length - 1
                    ? Container()
                    : nextButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget nextButton() {
    return Container(
      width: 100,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          // Increment activeStep, when the next button is tapped. However, check for upper bound.
          if (activeStep < widget.quiz!.question!.length - 1) {
            setState(() {
              activeStep++;
            });
          }
        },
        child: Text('Next'),
      ),
    );
  }

  /// Returns the previous button.
  Widget previousButton() {
    return Container(
      width: 100,
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
          if (activeStep > 0) {
            setState(() {
              activeStep--;
            });
          }
        },
        child: Text('Back'),
      ),
    );
  }
}
