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

Set<String> getAllTypes(String csvContent, String delimiter) {
  final lines = csvContent.split('\n');
  final questionData = lines
      .map((line) => line.split(delimiter).map((cell) => cell.trim()).toList())
      .toList();
  final types = questionData
      .where((question) =>
          question.length >=
          3) // Filter out questions with less than 3 elements
      .map((question) => question.elementAt(2))
      .toSet()
      .skip(1); // Skip the first element in the set

  Set<String> result = new Set();
  for (final type in types) {
    if (questionData.any((question) =>
        question.length > 2 &&
        question.elementAt(2) == type &&
        question.elementAt(2) != null)) {
      result.add(type);
    }
  }
  result.add('ALL');
  return result;
}
