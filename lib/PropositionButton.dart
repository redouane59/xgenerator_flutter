import 'package:flutter/material.dart';

class PropositionButton extends StatelessWidget {
  final List<String> propositions;
  final Function getCurrentQuestionData;
  final Function checkAnswer;
  final List<Color> buttonColors;

  PropositionButton({
    required this.propositions,
    required this.getCurrentQuestionData,
    required this.checkAnswer,
    required this.buttonColors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(propositions.length, (index) {
        String proposition = propositions[index];
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                checkAnswer(
                  getCurrentQuestionData()['expected_word']['output'],
                  proposition,
                  index,
                );
              },
              child: Text(
                proposition,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(double.infinity, 50),
                ),
                minimumSize: MaterialStateProperty.all(Size(200, 0)),
                backgroundColor: MaterialStateProperty.all<Color>(
                  buttonColors[index],
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
          ],
        );
      }),
    );
  }
}