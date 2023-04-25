import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/config/ConfigComponent.dart';

import 'utils.dart';

class FreeTextComponent extends StatefulWidget {
  final String csvContent;
  final Function updateCSVContent;

  FreeTextComponent({required this.csvContent, required this.updateCSVContent});

  @override
  _FreeTextComponentState createState() => _FreeTextComponentState();
}

class _FreeTextComponentState extends State<FreeTextComponent> {
  String delimiterString = 'Comma (,)';
  List<String> delimiterItems = ['Comma (,)', 'Semicolon (;)', 'Tab (\\t)'];
  String detectedDelimiter = '';
  Set<String> allTypes = new Set();

  @override
  void initState() {
    super.initState();
    if (widget.csvContent.isEmpty) {
      loadCSV().then((value) {
        setState(() {
          widget.updateCSVContent(value);
          detectedDelimiter = detectDelimiter(value);
          delimiterString = delimiterItems.firstWhere(
            (element) => getDelimiterCharacter(element) == detectedDelimiter,
            orElse: () => delimiterString,
          );
        });
      });
    }
  }

  Future<String> loadCSV() async {
    final response = await http.get(Uri.parse("algerian basics.csv"));
    return utf8.decode(response.bodyBytes);
  }

  void onInput(String value) {
    setState(() {
      widget.updateCSVContent(value);
      allTypes = getAllTypes(value, detectDelimiter(value));
      detectedDelimiter = detectDelimiter(value);
      delimiterString = delimiterItems.firstWhere(
        (element) => getDelimiterCharacter(element) == detectedDelimiter,
        orElse: () => delimiterString,
      );
    });
  }

  void clearContent() {
    setState(() {
      widget.updateCSVContent('');
      detectedDelimiter = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // spécifie la direction de gauche à droite
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: Text("Paste here your own exercice data")),
            SizedBox(height: 4.0),
            Text(
              'question,answer,type(optional)',
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
                child: Stack(
                  children: [
                    TextField(
                      onChanged: onInput,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: widget.csvContent,
                          selection: TextSelection.fromPosition(
                            TextPosition(offset: widget.csvContent.length),
                          ),
                        ),
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter CSV data here',
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: clearContent,
                        icon: Icon(Icons.delete),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.0),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Delimiter'),
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
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 110.0, // button padding bottom
                child: ConfigComponent(
                    csvContent: widget.csvContent,
                    allTypes: allTypes,
                    selectedTypeNotifier: ValueNotifier("ALL")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
