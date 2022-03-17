part of 'counter_bloc.dart';

@immutable
abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class CounterEventIncrement extends CounterEvent {
  const CounterEventIncrement(String value) : super(value);
}

class CounterEventDecrement extends CounterEvent {
  const CounterEventDecrement(String value) : super(value);
}
