import 'package:rxdart/rxdart.dart';

import '../model/counter_model.dart';
import '../impl/counter_impl.dart';

class CounterPageBloc implements CounterImpl {
  CounterModel _counterModel = CounterModel(0);
  BehaviorSubject<CounterModel> _controller = BehaviorSubject<CounterModel>();

  @override
  get counterModel => _controller.stream;

  @override
  void increment() {
    _counterModel = CounterModel(_counterModel.value+1);
    _controller.sink.add(_counterModel);
  }

  init() {
    _controller.sink.add(_counterModel);
  }

  dispose() {
    _controller.close();
  }
}
