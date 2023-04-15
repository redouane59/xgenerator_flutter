import 'package:flutter/material.dart';
import 'PropositionButton.dart';
import 'AutocompleteComponent.dart';

class QuestionComponent extends StatefulWidget {
  final List<dynamic> questionData;
  final bool isQuizz;

  const QuestionComponent({
    Key? key,
    required this.questionData,
    required this.isQuizz,
  }) : super(key: key);

  @override
  _QuestionComponentState createState() => _QuestionComponentState();
}

class _QuestionComponentState extends State<QuestionComponent> {
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  Map<String, dynamic> getCurrentQuestionData() {
    return widget.questionData[currentQuestionIndex];
  }

  void checkAnswer(String expected, String actual) {
    print('index: $currentQuestionIndex');
    if (expected == actual) {
      setState(() { currentQuestionIndex++; });
    } else {
    }
  }

  void skipQuestion() {
    setState(() {
      currentQuestionIndex = (currentQuestionIndex + 1) % widget.questionData.length;
    });
  }

  List<String> getPropositions() {
    print('getPropositions()');
    var propositions = getCurrentQuestionData()['propositions'];
    return List<String>.from(propositions.map((prop) => prop['output']).toList())
      ..shuffle();
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
          checkAnswer: checkAnswer,
        )
            : AutocompleteComponent(

        ),
      ],
    );
  }

}
