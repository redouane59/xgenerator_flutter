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