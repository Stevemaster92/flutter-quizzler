import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> score = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Ink(
                decoration: ShapeDecoration(
                  color: Colors.green,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  iconSize: 48.0,
                  icon: Text(
                    'True',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () => checkAnswer(true),
                ),
              ),
              Ink(
                decoration: ShapeDecoration(
                  color: Colors.red,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  iconSize: 48.0,
                  icon: Text(
                    'False',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => checkAnswer(false),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: score,
        )
      ],
    );
  }

  void checkAnswer(bool userAnswer) {
    setState(() {
      // Create score icon depending on the answer picked by the user.
      if (quizBrain.checkAnswer(userAnswer)) {
        score.add(Icon(Icons.check, color: Colors.green));
      } else {
        score.add(Icon(Icons.close, color: Colors.red));
      }
      // Check if the quiz has already reached the final question and show an alert.
      if (quizBrain.isFinished()) {
        Alert(
          context: context,
          title: "Congrats!",
          desc:
              "You have finished the quiz and you answered ${getNumberOfCorrectAnswers()} out of ${score.length} questions correctly.",
        ).show();
        // Reset the quiz and clear the score immediately.
        quizBrain.reset();
        score.clear();
      } else {
        // Otherwise, go to the next question.
        quizBrain.nextQuestion();
      }
    });
  }

  int getNumberOfCorrectAnswers() => score.fold(
      0, (prev, element) => element.icon == Icons.check ? prev + 1 : prev);
}
