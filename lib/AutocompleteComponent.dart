import 'package:flutter/material.dart';

class AutocompleteComponent extends StatefulWidget {
  final List<String> autocompleteItems;
  final Function checkAnswer;
  final Function getCurrentQuestionData;
  final Function onSkip;

  AutocompleteComponent({
    required this.autocompleteItems,
    required this.checkAnswer,
    required this.getCurrentQuestionData,
    required this.onSkip,
  });

  @override
  _AutocompleteComponentState createState() => _AutocompleteComponentState();
}

class _AutocompleteComponentState extends State<AutocompleteComponent> {
  TextEditingController? _autoCompleteController;
  bool _isCorrect = true;

  @override
  void dispose() {
    _autoCompleteController?.dispose();
    super.dispose();
  }

  void _resetAutoComplete() {
    print('resetAutoComplete');
    setState(() {
      _autoCompleteController?.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  return widget.autocompleteItems.where((String option) {
                    return option
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  bool isCorrect = widget.checkAnswer(
                    widget.getCurrentQuestionData()['expected_word']['output'],
                    selection,
                    -1,
                  );
                  setState(() {
                    _isCorrect = isCorrect;
                  });
                  _resetAutoComplete();
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  _autoCompleteController = textEditingController;

                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: 'Autocomplete',
                      errorText: _isCorrect ? null : 'Incorrect',
                      errorStyle: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  );
                },
                displayStringForOption: (String option) => option,
              ),
            ),
            SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: () => widget.onSkip(),
              child: Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }
}
