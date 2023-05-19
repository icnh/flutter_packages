import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  StyledText({
    super.key,
    required String text,
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
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.selectionRegistrar,
    this.selectionColor,
  })  : assert(maxLines == null || maxLines > 0),
        children = _parseTextSpans(text, arguments, styles);

  final List<InlineSpan> children;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final SelectionRegistrar? selectionRegistrar;
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: children,
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionRegistrar: selectionRegistrar,
      selectionColor: selectionColor,
    );
  }
}

/// Parses a string with `{n}` and `{style ...}` markup into a list of [TextSpan] objects.
List<InlineSpan> _parseTextSpans(String input, List<dynamic> arguments, Map<String, TextStyle> styles) {
  final children = <InlineSpan>[];
  final stack = <TextSpan>[TextSpan(children: children)];

  void append(String text) {
    stack.last.children!.add(TextSpan(text: text));
  }

  for (Match match in _tags.allMatches(input)) {
    if (match.group(1) != null) {
      final index = int.parse(match[1]!);
      if (index < arguments.length) {
        append("${arguments[index]}");
      } else {
        append("{$index}");
      }
    } else if (match.group(2) != null) {
      // ignore: prefer_const_literals_to_create_immutables
      final span = TextSpan(style: styles[match.group(2)], children: <InlineSpan>[]);
      stack.last.children!.add(span);
      stack.add(span);
    } else if (match.group(3) != null) {
      if (stack.length > 1) {
        stack.removeLast();
      } else {
        append('}');
      }
    } else {
      append(match[4]!.replaceAllMapped(_escapes, (match) => match[1] == 'n' ? '\n' : match[1]!));
    }
  }
  assert(stack.length == 1);
  return stack.last.children!;
}

// group 1 = argument, 2 = block start, 3 = block end, 4 = text (w/escapes)
final _tags = RegExp(r'\{(\d+)\}|\{(\w+)\s*|(\})|((?:\\[{}\\n]|[^{}])+|\{)');

// group 1 = character
final _escapes = RegExp(r'\\[{}\\n]');
