import 'package:flutter/material.dart';
import 'package:namer_app/PlayButtons.dart';

class FileInputComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          // Contenu principal de la page
          SingleChildScrollView(
            child: Column(
              children: [
                // ...
                // Le reste du contenu de la page
                // ...
              ],
            ),
          ),

          // Boutons en bas de la page
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100.0, // hauteur des boutons
              child: PlayButtons(csvContent: ""),
            ),
          ),
        ],
      ),
    );
  }
}
