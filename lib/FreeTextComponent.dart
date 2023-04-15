import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'utils.dart';
import 'package:namer_app/PlayButtons.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class FreeTextComponent extends StatefulWidget {
  @override
  _FreeTextComponentState createState() => _FreeTextComponentState();
}

class _FreeTextComponentState extends State<FreeTextComponent> {
  String csvContent = '';
  String delimiterString = 'Comma (,)';
  List<String> delimiterItems = ['Comma (,)', 'Semicolon (;)', 'Tab (\\t)'];
  String detectedDelimiter = '';


  @override
  void initState() {
    super.initState();
    loadCSV().then((value) {
      setState(() {
        csvContent = value;
        detectedDelimiter = detectDelimiter(value);
        delimiterString = delimiterItems.firstWhere(
              (element) => getDelimiterCharacter(element) == detectedDelimiter,
          orElse: () => delimiterString,
        );
      });
    });
  }

  Future<String> loadCSV() async {
    return await rootBundle.loadString('assets/sample.csv');
  }

  void onInput(String value) {
    setState(() {
      csvContent = value;
      detectedDelimiter = detectDelimiter(value);
      delimiterString = delimiterItems.firstWhere(
            (element) => getDelimiterCharacter(element) == detectedDelimiter,
        orElse: () => delimiterString,
      );
    });
  }

  void clearContent() {
    setState(() {
      csvContent = '';
      detectedDelimiter = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 4.0),
            Text(
              'intput,output,type(optional)',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: TextField(
                  onChanged: onInput,
                  controller: TextEditingController(text: csvContent),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter CSV data here',
                    contentPadding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.0),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Delimiter',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  DropdownButton<String>(
                    value: delimiterString,
                    onChanged: (String? newValue) {
                      setState(() {
                        delimiterString = newValue!;
                      });
                    },
                    items: delimiterItems.map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: clearContent,
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child: Text('CLEAR'),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100.0, // hauteur des boutons
                child: PlayButtons(csvContent: csvContent),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
