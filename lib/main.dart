import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('home page'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalid) ? state.invalidValue : '';

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Current value => ${state.value}'),
                  Visibility(
                      child: Text('Invalid value => $invalidValue'),
                      visible: invalidValue.isNotEmpty),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter a value',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      TextButton(
                        child: const Text('Increment'),
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(CounterEventIncrement(_controller.text));
                        },
                      ),
                      TextButton(
                        child: const Text('Decrement'),
                        onPressed: () {
                          context
                              .read()
                              .add(CounterEventDecrement(_controller.text));
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalid extends CounterState {
  final String invalidValue;
  const CounterStateInvalid({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

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

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0))
   {
    on<CounterEventIncrement>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalid(
          invalidValue: event.value,
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
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}
