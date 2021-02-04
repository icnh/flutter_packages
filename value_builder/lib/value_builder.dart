import 'package:flutter/widgets.dart';
import 'package:value_builder/value.dart';

export 'package:value_builder/value.dart';

/// A widget that automatically rebuilds if an observed value changes.
/// Similar but simpler than a [FutureBuilder] or [StreamBuilder].
class ValueBuilder<T> extends StatelessWidget {
  final Value<T> value;
  final Widget Function(BuildContext, T) builder;

  /// Constructs a new widget that calls [builder] each time [value] changes.
  const ValueBuilder({Key key, this.value, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: value,
      builder: (context, child) => builder(context, value.value),
    );
  }
}
