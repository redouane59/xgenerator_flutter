import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final String buttonText;
  final bool isQuizz;
  final VoidCallback onPressed;

  const PlayButton({
    required this.buttonText,
    required this.isQuizz,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }
}
