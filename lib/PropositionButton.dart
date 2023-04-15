import 'package:flutter/material.dart';

class PropositionButton extends StatelessWidget {
  final List<String> propositions;
  final Function getCurrentQuestionData;
  final Function checkAnswer;

  PropositionButton({
    required this.propositions,
    required this.getCurrentQuestionData,
    required this.checkAnswer,
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
                print('onPressed PropositionButton ');
                checkAnswer(
                  getCurrentQuestionData()['expected_word']['output'],
                  proposition,
                );
              },
              child: Text(proposition),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(double.infinity, 50),
                ),
                minimumSize: MaterialStateProperty.all(Size(200, 0)),
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
