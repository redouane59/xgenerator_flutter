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
  List<String> questionCountOptions = ['5', '10', '20', '40'];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "nb Questions",
                      textAlign: TextAlign.center,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: DropdownButton<String>(
                        value: questionCount,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              questionCount = newValue;
                              widget.questionCountCallback(questionCount);
                            });
                          }
                        },
                        isExpanded: true,
                        // Permet d'élargir la liste déroulante pour qu'elle prenne toute la largeur disponible
                        items: questionCountOptions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Align(
                              // Envelopper le contenu dans un Align pour le centrer
                              alignment: Alignment.center,
                              child: Text(
                                value,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.allTypes.length > 1)
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
