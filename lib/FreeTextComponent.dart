import 'package:flutter/material.dart';
import 'utils.dart';

class FreeTextComponent extends StatefulWidget {
  @override
  _FreeTextComponentState createState() => _FreeTextComponentState();
}

class _FreeTextComponentState extends State<FreeTextComponent> {
  String csvContent = '';
  String delimiterString = 'Comma (,)';
  List<String> delimiterItems = ['Comma (,)', 'Semicolon (;)', 'Tab (\\t)'];
  String detectedDelimiter = '';

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

  String getDelimiterCharacter(String delimiterLabel) {
    String delimiterChar;
    switch (delimiterLabel) {
      case "Comma (,)":
        delimiterChar = ",";
        break;
      case "Semicolon (;)":
        delimiterChar = ";";
        break;
      case "Tab (\\t)":
        delimiterChar = "\t";
        break;
      default:
        delimiterChar = ",";
        break;
    }
    return delimiterChar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'intput,output,type(optional)',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 300.0,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Expanded(
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
            Row(
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
            SizedBox(height: 16.0),



          ],
        ),
      ),
    );
  }
}
