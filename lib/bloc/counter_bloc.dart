import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'counter_event.dart';
part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<CounterEventIncrement>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalid(
          invalidValue:
              event.value.isNotEmpty ? event.value : 'Please Enter Some Value',
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(integer + state.value));
      }
    });

    on<CounterEventDecrement>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalid(
          invalidValue: event.value.isNotEmpty ? event.value : 'Please Enter Some Value',
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}
