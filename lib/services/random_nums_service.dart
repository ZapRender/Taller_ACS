import 'dart:isolate';
import 'dart:math';

Future<List<int>> runIsolates() async {
  final List<Future<int>> futures = [];
  for (int i = 0; i < 10; i++) {
    futures.add(runInIsolate(sumRandomNumbers));
  }
  return await Future.wait(futures);
}

Future<int> runInIsolate(Function function) async {
  final receivePort = ReceivePort();
  await Isolate.spawn(_isolateEntry, [function, receivePort.sendPort]);
  return await receivePort.first as int;
}

void _isolateEntry(List<dynamic> args) {
  final Function function = args[0];
  final SendPort sendPort = args[1];

  final result = function();
  sendPort.send(result);
}

int sumRandomNumbers() {
  final random = Random();
  int sum = 0;
  for (int i = 0; i < 100; i++) {
    sum += random.nextInt(1000) + 1;
  }
  return sum;
}