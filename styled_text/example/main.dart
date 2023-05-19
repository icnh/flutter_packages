import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: StyledText(
            text: 'Hello {b {0}}. plain, {i italics, {u and underlined}} text.',
            arguments: const ['World'],
          ),
        ),
      ),
    );
  }
}
