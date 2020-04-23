import '../model/counter_model.dart';

abstract class CounterImpl {
  Stream<CounterModel> _counterModel;
  get counterModel => _counterModel;

  void increment();
  void dispose();
}
