import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StyledText(
            text: 'Hello {b {0}}. plain, {i italics, {u and underlined}} text.',
            arguments: ['World'],
          ),
        ),
      ),
    );
  }
}
