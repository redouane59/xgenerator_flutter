import 'package:flutter/material.dart';
import 'package:namer_app/PlayButtons.dart';

import 'QuestionComponent.dart';
import 'main.dart';

class ResultPage extends StatelessWidget {
  final int score;
  final int questionCount;
  List<dynamic> wrongQuestions;
  final String csvContent;

  ResultPage({
    required this.score,
    required this.questionCount,
    required this.wrongQuestions,
    required this.csvContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score: $score / $questionCount',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
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
                        questionData: wrongQuestions,
                        isQuizz: true,
                        csvContent: csvContent,
                        allOuputs: [], // @todo to fix
                      ),
                    ),
                  );
                },
                child: Text('Play (Correction)'),
              ),
            if (!wrongQuestions.isNotEmpty) PlayButtons(csvContent: csvContent)
          ],
        ),
      ),
    );
  }
}
