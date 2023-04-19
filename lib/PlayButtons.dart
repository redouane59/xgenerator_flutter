import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/utils.dart';

import 'PlayButton.dart';
import 'QuestionComponent.dart';

class PlayButtons extends StatefulWidget {
  final String csvContent;

  PlayButtons({required this.csvContent});

  @override
  _PlayButtonsState createState() => _PlayButtonsState();
}

class _PlayButtonsState extends State<PlayButtons> {
  String questionCount = '5';
  List<String> questionCountOptions = ['5', '10', '20', 'ALL'];

  void showErrorDialog(BuildContext context, String errorDetails) {
    print('showErrorDialog');
    print('context $context');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Processing error"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("An error occurred during the processing of your file. "
                    "Please check your file content and its delimiters."),
                SizedBox(height: 8.0),
                Text("Error detail :"),
                Text(errorDetails),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isCsvEmpty = widget.csvContent.isEmpty;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: questionCount,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  questionCount = newValue;
                });
              }
            },
            items: questionCountOptions
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(width: 16.0),
          PlayButton(
            buttonText: 'Play (Quizz)',
            isQuizz: true,
            isEnabled: widget.csvContent.isNotEmpty,
            onPressed: () {
              if (widget.csvContent.isNotEmpty) {
                onPlayButtonPressed(context, true);
              }
            },
          ),
          SizedBox(width: 16.0),
          PlayButton(
            buttonText: 'Play (Expert)',
            isQuizz: false,
            isEnabled: widget.csvContent.isNotEmpty,
            onPressed: () {
              if (widget.csvContent.isNotEmpty) {
                onPlayButtonPressed(context, false);
              }
            },
          ),
        ],
      ),
    );
  }

  List<String> getAllOutputs(String csvContent, String delimiter) {
    final lines = csvContent.split('\n');
    final questionData = lines
        .map(
            (line) => line.split(delimiter).map((cell) => cell.trim()).toList())
        .toList();
    final outputs = questionData.map((question) => question[1]).toSet().skip(1);
    return outputs.cast<String>().toList();
  }

  Future<Map<String, dynamic>?> callApi(
      BuildContext context, String csvContent, String delimiter) async {
    String rootUrl =
        'https://us-central1-dz-dialect-api.cloudfunctions.net/generate-question-function';
    if (kDebugMode) {
      rootUrl = 'http://localhost:8080';
    }
    Null type = null;
// &type=$type
    String url =
        '$rootUrl?question_count=$questionCount&delimiter=${Uri.encodeComponent(delimiter)}';
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
        showErrorDialog(context, errorData);
        return null;
      }
      final jsonResponse = await response.stream.bytesToString();
      return json.decode(jsonResponse);
    } catch (error) {
      showErrorDialog(context, error.toString());
      return null;
    }
  }

  // @todo bug here, is Quizz is always true even clicking on the button where it should be false
  void onPlayButtonPressed(BuildContext context, bool isQuizz) async {
    String delimiter = detectDelimiter(widget.csvContent);
    final jsonResponse = await callApi(context, widget.csvContent, delimiter);
    if (jsonResponse != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestionComponent(
            questionData: jsonResponse["questions"],
            isQuizz: isQuizz,
            csvContent: widget.csvContent,
            allOuputs: getAllOutputs(widget.csvContent, delimiter),
          ),
        ),
      );
    }
  }
}
