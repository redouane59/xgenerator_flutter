import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final String buttonText;
  final bool isQuizz;
  final bool isEnabled;
  final VoidCallback onPressed;

  const PlayButton({
    required this.buttonText,
    required this.isQuizz,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      child: Text(buttonText),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Theme.of(context).disabledColor;
            }
            return Theme.of(context).primaryColor;
          },
        ),
        minimumSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.3, 50),
        ),
      ),
    );
  }
}
