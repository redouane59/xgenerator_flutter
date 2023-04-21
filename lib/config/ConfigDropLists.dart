import 'package:flutter/material.dart';

class ConfigDropLists extends StatefulWidget {
  final Set<String> allTypes;
  final Function(String) questionCountCallback;
  final Function(String) typeCallback;

  ConfigDropLists({
    required this.allTypes,
    required this.questionCountCallback,
    required this.typeCallback,
  });

  @override
  _ConfigBar createState() => _ConfigBar();
}

class _ConfigBar extends State<ConfigDropLists> {
  String questionCount = '5';
  String selectedType = 'ALL';
  List<String> questionCountOptions = ['5', '10', '20', 'ALL'];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text("nb Questions"),
                  DropdownButton<String>(
                    value: questionCount,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          questionCount = newValue;
                          widget.questionCountCallback(questionCount);
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
                ],
              ),
              SizedBox(width: 16.0),
              if (widget.allTypes.isNotEmpty)
                Column(
                  children: [
                    Text("Types"),
                    DropdownButton<String>(
                      value: selectedType,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedType = newValue;
                            widget.typeCallback(newValue);
                          });
                        }
                      },
                      items: widget.allTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
