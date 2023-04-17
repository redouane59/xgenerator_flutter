import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:namer_app/PlayButtons.dart';

class FileInputComponent extends StatefulWidget {
  @override
  _FileInputComponentState createState() => _FileInputComponentState();
}

class _FileInputComponentState extends State<FileInputComponent> {
  String csvContent = "";
  String fileName = "";

  Future<void> _pickCsvFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      String fileContent;

      if (kIsWeb) {
        // Sur la plateforme web, utilisez bytes pour lire le contenu du fichier
        Uint8List bytes = result.files.single.bytes!;

        // Détectez l'encodage
        Encoding encoding = Encoding.getByName('utf-8') ?? utf8;

        // Utilisez l'encodage détecté pour convertir les bytes en chaîne de caractères
        fileContent = encoding.decode(bytes);
      } else {
        // Sur les autres plateformes, utilisez path pour lire le contenu du fichier
        File file = File(result.files.single.path!);

        // Détectez l'encodage
        List<int> fileBytes = await file.readAsBytes();
        Encoding encoding = Encoding.getByName('utf-8') ?? utf8;

        // Utilisez l'encodage détecté pour convertir les bytes en chaîne de caractères
        fileContent = encoding.decode(fileBytes);
      }

      setState(() {
        csvContent = fileContent;
        fileName = result.files.single.name;
      });
    } else {
      // L'utilisateur a annulé la sélection du fichier
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickCsvFile,
                    icon: Icon(Icons.upload_file),
                    label: Text('Choose a CSV file'),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    fileName ?? '',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100.0,
              child: PlayButtons(csvContent: csvContent),
            ),
          ),
        ],
      ),
    );
  }
}
