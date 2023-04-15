import 'dart:io';
import 'package:http/http.dart' as http;

String detectDelimiter(String text) {
  final delimiters = [",", ";", "\t"];
  var maxDelimiters = 0;
  var detectedDelimiter = ",";
  for (final delimiter in delimiters) {
    final numDelimiters = text.split(delimiter).length - 1;
    if (numDelimiters > maxDelimiters) {
      maxDelimiters = numDelimiters;
      detectedDelimiter = delimiter;
    }
  }
  return detectedDelimiter;
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
