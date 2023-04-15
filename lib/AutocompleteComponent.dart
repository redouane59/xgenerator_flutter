import 'package:flutter/material.dart';

class AutocompleteComponent extends StatefulWidget {
  final List<String> autocompleteItems;
  final Function checkAnswer;
  final Function getCurrentQuestionData;

  AutocompleteComponent({
    required this.autocompleteItems,
    required this.checkAnswer,
    required this.getCurrentQuestionData,
  });

  @override
  _AutocompleteComponentState createState() => _AutocompleteComponentState();
}

class _AutocompleteComponentState extends State<AutocompleteComponent> {
  final _autoCompleteController = TextEditingController();
  String? _selectedItem;

  @override
  void dispose() {
    _autoCompleteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
          print('on selected');
          setState(() {
            _autoCompleteController.text = selection;
            _selectedItem = selection;
          });

          widget.checkAnswer(
            widget.getCurrentQuestionData()['expected_word']['output'],
            selection,
            -1,
          );
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          _autoCompleteController.value = textEditingController.value;
          return TextFormField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: 'Autocomplete',
            ),
            onChanged: (value) {
              setState(() {
                _selectedItem = value;
              });
            },
          );
        },
        displayStringForOption: (String option) => option,
      ),
    );
  }
}
