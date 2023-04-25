import 'package:flutter/material.dart';

import 'config/ConfigComponent.dart';
import 'main.dart';
import 'question/QuestionComponent.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final int questionCount;
  Set<dynamic> wrongQuestions;
  final String csvContent;

  ResultPage({
    required this.score,
    required this.questionCount,
    required this.wrongQuestions,
    required this.csvContent,
  });

  void _onBackHomePressed(BuildContext context) {
    Navigator.popUntil(
        context,
        ModalRoute.withName(
            '/home')); // Remplacez '/home' par le nom de votre route de la page d'accueil
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score: $score / $questionCount',
              style: TextStyle(fontSize: 36),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyApp(csvContent: csvContent)),
                );
              },
              child: Text('Back Home'),
            ),
            SizedBox(height: 16),
            if (wrongQuestions.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionComponent(
                        questionData: List.of(wrongQuestions),
                        isQuizz: true,
                        csvContent: csvContent,
                        allOuputs: [], // @todo to fix
                      ),
                    ),
                  );
                },
                child: Text('Play (Correction)'),
              ),
            if (wrongQuestions.isEmpty)
              ConfigComponent(
                  csvContent: csvContent,
                  allTypes: new Set(),
                  selectedTypeNotifier: ValueNotifier("ALL"))
          ],
        ),
      ),
    );
  }
}
