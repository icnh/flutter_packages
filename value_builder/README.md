Value Builder
=============

A simple observable variable plus builder widget.

Usage
-----

Create a new `Subject`. It has a `value` property to get and set its value. Use its `stream` property to get the current value and all future values as an asynchronous `Stream`. 

Use the `SubjectBuilder` widget the same way as a `StreamBuilder` to make parts of your UI dependent on the provided `Subject`. In comparison to the `StreamBuilder`, its interface is simpler as you don't have to deal with missing values or error conditions.

Example
-------

```dart
final counter = Value(0);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ValueBuilder<int>(
          value: counter,
          builder: (context, count) {
            return Text('$count');
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => counter.value += 1,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
```
