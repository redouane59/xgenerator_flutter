import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'PlayButton.dart';
import 'QuestionComponent.dart';

class PlayButtons extends StatelessWidget {
  final String csvContent;

  PlayButtons({required this.csvContent});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlayButton(
            buttonText: 'Play (Quizz)',
            isQuizz: true,
            onPressed: () => onPlayButtonPressed(context, true),
          ),
          SizedBox(width: 16.0),
          PlayButton(
            buttonText: 'Play (Expert)',
            isQuizz: false,
            onPressed: () => onPlayButtonPressed(context, false),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> callApi(String csvContent, String delimiter) async {
    String rootUrl = 'https://us-central1-dz-dialect-api.cloudfunctions.net/generate-question-function';
    if (kDebugMode) {
      rootUrl = 'http://localhost:8080';
    }
    int questionCount = 20;
    Null type = null;
// &type=$type
    String url = '$rootUrl?question_count=$questionCount&delimiter=${Uri
        .encodeComponent(delimiter)}';
    print('calling URL $url');

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          utf8.encode(csvContent),
          filename: 'file.csv',
        ),
      );
      final response = await request.send();
      if (response.statusCode != 200) {
        final errorData = json.decode(await response.stream.bytesToString());
        print("Une erreur s'est produite lors de l'appel à l'API.");
        print(errorData);
        return null;
      }
      final jsonResponse = await response.stream.bytesToString();
      return json.decode(jsonResponse);
    } catch (error) {
      print(error);
      return null;
    }
  }

  void onPlayButtonPressed(BuildContext context, bool isQuizz) async {
    final jsonResponse = await callApi(csvContent, ',');
    if (jsonResponse != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionComponent(
            questionData: jsonResponse["questions"],
            isQuizz: isQuizz,
          ),
        ),
      );
    }
  }

}