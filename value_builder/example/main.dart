import 'package:flutter/material.dart';
import 'package:value_builder/value_builder.dart';
import 'package:value_builder/value_provider.dart';

void main() => runApp(ValueProvider(Model(), child: MyApp()));

class Model {
  final counter = Value(0);

  static Model of(BuildContext context) => ValueProvider.of(context);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Model.of(context);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ValueBuilder<int>(
            value: model.counter,
            builder: (context, count) {
              return Text('$count', textScaleFactor: 10);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => model.counter.value += 1,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
