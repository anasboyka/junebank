class StructuredFormatingText {
  final String mainText;
  final String secondaryText;

  StructuredFormatingText({this.mainText, this.secondaryText});

  factory StructuredFormatingText.fromJson(Map<String, dynamic> parsedJson) {
    return StructuredFormatingText(
      mainText: parsedJson['main_text'],
      secondaryText: parsedJson['secondary_text'],
    );
  }
}
