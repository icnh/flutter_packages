import 'package:flutter/widgets.dart';

/// Provides a value (actually anything of type [T]) to ancestor widgets.
///
/// To access the provided [T] instance, implement something like this:
/// ```
/// class Store {
///   static Store of(BuildContext context) => StoreProvider.of(context);
/// }
/// ```
class ValueProvider<T> extends InheritedWidget {
  /// The provided value.
  final T value;

  /// Constructs a new value provider. You must pass a [value], which can be
  /// anything that will be returned if you call [ValueProvider.of()] in the
  /// context of [child] or some ancestor of that widget.
  ValueProvider(
    this.value, {
    Key key,
    Widget child,
  })  : assert(value != null),
        super(key: key, child: child);

  /// Returns the value of the nearest inherited [ValueProvider] for type [T].
  static T of<T>(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_typeOf<ValueProvider<T>>()) as ValueProvider<T>)?.value;
  }

  // workaround to capture generics
  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(ValueProvider<T> oldWidget) {
    return oldWidget.value != value;
  }
}
