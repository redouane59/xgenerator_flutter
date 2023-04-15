import 'package:dio/src/form_data.dart';

import 'package:flutter/material.dart';
import 'FreeTextComponent.dart';
import 'FileInputComponent.dart';
import 'SelectFileList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Train Me!'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.paste),
              label: 'Paste raw text',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.upload_file),
              label: 'Import a CSV file',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_open),
              label: 'Existing exercises',
            ),
          ],
          currentIndex: _activeTabIndex,
          onTap: (int index) {
            setState(() {
              _activeTabIndex = index;
            });
          },
        ),
        body: IndexedStack(
          index: _activeTabIndex,
          children: [
            FreeTextComponent(),
            FileInputComponent(),
            SelectFileList(),
          ],
        ),
      ),
    );
  }


}

