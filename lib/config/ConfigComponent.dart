import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/utils.dart';

import '../question/QuestionComponent.dart';
import 'ConfigDropLists.dart';
import 'PlayButton.dart';

class ConfigComponent extends StatefulWidget {
  final String csvContent;
  final Set<String> allTypes;
  final ValueNotifier<String> selectedTypeNotifier;

  ConfigComponent(
      {required this.csvContent,
      required this.allTypes,
      required this.selectedTypeNotifier});

  @override
  _ConfigComponentState createState() => _ConfigComponentState();
}

class _ConfigComponentState extends State<ConfigComponent> {
  String questionCount = '5';
  String selectedType = 'ALL';

  @override
  void initState() {
    super.initState();
    widget.selectedTypeNotifier.addListener(_updateSelectedType);
  }

  @override
  void dispose() {
    widget.selectedTypeNotifier.removeListener(_updateSelectedType);
    super.dispose();
  }

  void _updateSelectedType() {
    setState(() {
      selectedType = widget.selectedTypeNotifier.value;
      print('set state $selectedType');
    });
  }

  @override
  Widget build(BuildContext context) {
/*    if (widget.allTypes.length < 2) {
      setState(() {
        selectedType = 'ALL';
      });
    }*/
    return Center(
      child: Column(
        children: [
          SizedBox(width: 16.0),
          ConfigDropLists(
            allTypes: widget.allTypes,
            questionCountCallback: updateQuestionCount,
            typeCallback: updateType,
          ),
          SizedBox(width: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
        ],
      ),
    );
  }

  void updateQuestionCount(String newCount) {
    setState(() {
      if (newCount == "ALL") {
        questionCount = "-1"; // generate all questions
      } else {
        questionCount = newCount;
      }
    });
  }

  void updateType(String newType) {
    setState(() {
      selectedType = newType;
    });
  }

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

    String url =
        '$rootUrl?question_count=$questionCount&delimiter=${Uri.encodeComponent(delimiter)}';

    // @todo dirty
    if (selectedType != "ALL") {
      url += "&type=$selectedType";
    }
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
    if (jsonResponse != null && jsonResponse["questions"].length > 0) {
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
    } else {
      print('error, API jsonResponse was null or empty');
    }
  }
}
