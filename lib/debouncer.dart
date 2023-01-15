import 'dart:async';
import 'dart:ui';

final postsDebouncer = Debouncer();

class Debouncer {
  Timer? timer;

  run(VoidCallback action, int millis) {
    if (timer?.isActive != true) {
      action();
      timer?.cancel();
      timer = Timer(Duration(milliseconds: millis), () => timer?.cancel());
    }
  }

  runLazy(VoidCallback action, int millis) {
    final duration = Duration(milliseconds: millis);
    timer?.cancel();
    timer = Timer(duration, () => action());
  }
}
