import 'dart:ui';

//ensure a function runs only once
class SingleRunner {
  bool _shouldRun = true;

  void resetAndRun(VoidCallback callback) {
    _shouldRun = true;
    runOnce(callback);
  }

  void runOnce(VoidCallback callback) {
    if (_shouldRun) {
      _shouldRun = false;
      callback.call();
    }
  }
}