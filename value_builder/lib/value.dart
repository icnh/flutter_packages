import 'package:flutter/foundation.dart';

/// A listenable value.
/// 
/// See [ValueBuilder].
class Value<T> extends ChangeNotifier {
  T _value;

  bool Function(T, T) _equals;

  /// Constructs a new listenable value with [_value] as initial value and
  /// [_equals] as optional comparison function to make values distrinct.
  Value(this._value, [this._equals]);

  /// Returns the subject's current value.
  T get value => _value;

  /// Sets [value] as next value which is automatically emitted to all
  /// listeners if (and only if) it is not equal to the previous one.
  set value(T value) {
    Future(() {
      if (_equals == null ? _value != value : !_equals(_value, value)) {
        _value = value;
        notifyListeners();
      }
    });
  }
}

/// A listenable computation dependent on other [Listenable]s.
/// 
/// See [Value] and [ValueBuilder].
class Computation<T> extends Value<T> {
  final T Function() _compute;

  final List<Listenable> _dependencies;

  /// Constructs a new listenable computation which is re-evaluated using
  /// [_compute] each time any of its [_dependencies] changes. The computation
  /// results are made distrinct using the optional [equals] comparison function.
  Computation(this._compute, this._dependencies, [bool Function(T, T) equals]) : super(_compute(), equals) {
    for (final d in _dependencies) {
      d.addListener(_update);
    }
  }

  void dispose() {
    super.dispose();
    for (final d in _dependencies) {
      d.removeListener(_update);
    }
  }

  void _update() {
    value = _compute();
  }
}

/// A listenable master/detail computation.
/// 
/// See [Value], [Computation] and [ValueBuilder].
class MasterDetailValue<T> extends Computation<T> {
  final Value<List<T>> items;

  final Value<int> index;

  MasterDetailValue._(this.items, this.index, T Function() compute) : super(compute, [items, index]);

  /// Constructs a new master/detail computation that recomputes the selected
  /// value based on [items] and [index]. If [items] is smaller than the current
  /// value of [index], it is automatically adjusted to the last possible value
  /// or to -1 if [items]'s value is an empty list.
  factory MasterDetailValue(List<T> initialItems, [int initialIndex = -1]) {
    Value<List<T>> items = Value(initialItems);
    Value<int> index = Value(initialIndex);
    return MasterDetailValue._(items, index, () {
      if (index.value == -1) return null;
      if (index.value >= items.value.length) index.value = items.value.length - 1;
      return items.value[index.value];
    });
  }

  void dispose() {
    super.dispose();
    items.dispose();
    index.dispose();
  }
}
