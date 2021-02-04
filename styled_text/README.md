Styled Text
===========

A widget to easily create `RichText` from a string. This is useful especially if those strings shall be localized. Even if you don't need styles, the text replacement function might be useful.

Usage
-----

Use `StyledText` like `Text`. Use the optional `arguments` property to specify arguments which are inserted where `{number}` (_number_ must be an non-negative integer less than the length of the provided arguments list) occurs. Use the optional `styles` property to provide a mapping from names to `TextStyle` objects.

Example
-------

```dart
StyledText(
  text: '{red Warning:} {0}!'
  arguments: ['This is the message'],
  styles: {'red': TextStyle(color: Colors.red)},
);
```
