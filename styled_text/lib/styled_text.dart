import 'package:flutter/material.dart' show Theme;
import 'package:flutter/widgets.dart';

/// A replacement for `Text` that displays styled text like `RichText` by
/// parsing a format string containing styled chunks of text in curly braces.
/// Like `Text` and unlike `RichText`, a default text style is used
/// automatically.
///
/// By default bold, italic and underlined text is supported. Those [styles]
/// can be overwritten, though. Each occurence of `{name ...}` is replaced
/// by a `TextSpan` with the style registered for `name` in. Styles can be
/// nested.
///
/// Furthermore, occurences of `{number}` are replaced by stringified versions
/// of the provided [arguments] list.
///
/// ```dart
/// StyledText(
///   text: '{red Warning:} {0}!'
///   arguments: ['This is the message'],
///   styles: {'red': TextStyle(color: Colors.red)},
/// )
/// ```
class StyledText extends StatelessWidget {
  final List<TextSpan> children;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final Locale locale;

  StyledText({
    Key key,
    @required String text,
    List<dynamic> arguments = const [],
    Map<String, TextStyle> styles = const {
      "b": TextStyle(fontWeight: FontWeight.bold),
      "i": TextStyle(fontStyle: FontStyle.italic),
      "u": TextStyle(decoration: TextDecoration.underline),
    },
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
  })  : assert(styles != null),
        assert(textAlign != null),
        assert(softWrap != null),
        assert(textScaleFactor != null),
        assert(maxLines == null || maxLines > 0),
        children = _parseTextSpans(text, arguments, styles),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.body1,
        children: children,
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
    );
  }
}

/// Parses a string with `{n}` and `{style ...}` markup into a list of [TextSpan] objects.
List<TextSpan> _parseTextSpans(String input, List<dynamic> arguments, Map<String, TextStyle> styles) {
  final stack = <TextSpan>[TextSpan(children: [])];

  void append(String text) {
    stack.last.children.add(TextSpan(text: text));
  }

  for (Match match in _tags.allMatches(input)) {
    if (match.group(1) != null) {
      final index = int.parse(match.group(1));
      if (index < arguments.length) {
        append("${arguments[index]}");
      } else {
        append("{$index}");
      }
    } else if (match.group(2) != null) {
      final span = TextSpan(style: styles[match.group(2)], children: []);
      stack.last.children.add(span);
      stack.add(span);
    } else if (match.group(3) != null) {
      if (stack.length > 1)
        stack.removeLast();
      else
        append('}');
    } else {
      append(match.group(4).replaceAllMapped(
            _escapes,
            (match) => match.group(1) == 'n' ? '\n' : match.group(1),
          ));
    }
  }
  assert(stack.length == 1);
  return stack.last.children;
}

// group 1 = argument, 2 = block start, 3 = block end, 4 = text (w/escapes)
final _tags = RegExp(r'\{(\d+)\}|\{(\w+)\s*|(\})|((?:\\[{}\\n]|[^{}])+|\{)');

// group 1 = character
final _escapes = RegExp(r'\\[{}\\n]');
