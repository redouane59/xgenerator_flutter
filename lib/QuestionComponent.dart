import 'package:flutter/material.dart';
import 'PropositionButton.dart';
import 'AutocompleteComponent.dart';
import 'ResultPage.dart';

class QuestionComponent extends StatefulWidget {
  final List<dynamic> questionData;
  final bool isQuizz;
  final String csvContent;

  const QuestionComponent({
    Key? key,
    required this.questionData,
    required this.isQuizz,
    required this.csvContent,
  }) : super(key: key);

  @override
  _QuestionComponentState createState() => _QuestionComponentState();
}

class _QuestionComponentState extends State<QuestionComponent> {
  int currentQuestionIndex = 0;
  int score = 0;
  List<dynamic> wrongQuestions = [];
  List<Color> buttonColors = [];
  bool isWrong = false;

  @override
  void initState() {
    super.initState();
    initButtonColors();
  }

  void initButtonColors(){
    buttonColors = List.filled(widget.questionData[0]['propositions'].length, Colors.lightBlue);
  }

  Map<String, dynamic> getCurrentQuestionData() {
      return widget.questionData[currentQuestionIndex];
  }

  void checkAnswer(String expected, String actual, int buttonIndex) {
    bool isCorrect = (expected == actual);
    if (isCorrect) {
      setState(() {
        currentQuestionIndex++;
        score++;
        initButtonColors();
      });
      if (currentQuestionIndex == widget.questionData.length) {
        setState(() {
          currentQuestionIndex--;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              score: score,
              questionCount: widget.questionData.length,
              wrongQuestions: wrongQuestions,
              csvContent: widget.csvContent,
            ),
          ),
        );
      }
    } else {
      score--;
      wrongQuestions.add(getCurrentQuestionData());

      // Change the color of the button with the wrong answer
      setState(() {
        buttonColors[buttonIndex] = Colors.red;
      });
    }
  }

  void skipQuestion() {
    setState(() {
      currentQuestionIndex = (currentQuestionIndex + 1) % widget.questionData.length;
    });
  }

  List<String> getPropositions() {
    var propositions = getCurrentQuestionData()['propositions'];
    return List<String>.from(propositions.map((prop) => prop['output']).toList());
 //     ..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LinearProgressIndicator(
          value: (currentQuestionIndex + 1) / widget.questionData.length,
        ),
        Text(
          '${getCurrentQuestionData()['expected_word']['input']} ?',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        widget.isQuizz
            ? PropositionButton(
          propositions: getPropositions(),
          getCurrentQuestionData: getCurrentQuestionData,
            buttonColors: buttonColors,
          checkAnswer: checkAnswer
        )
            : AutocompleteComponent(

        ),
      ],
    );
  }

}
