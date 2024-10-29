import 'dart:convert';
import 'dart:io';

class ProcessService {
  Future<List<Map<String, String>>> getProcesses() async {
    final tasklistProc = await Process.run('tasklist', ['/NH', '/FO', 'csv', '/FI', 'STATUS eq RUNNING']);
    final stream = const LineSplitter().convert(tasklistProc.stdout);
    final processList = <Map<String, String>>[];

    for (var line in stream) {
      final elems = line.split(',').map((elem) => elem.replaceAll('"', '')).toList();
      if (elems.length > 1) {
        processList.add({'name': elems[0], 'pid': elems[1]});
      }
    }

    return processList;
  }

  Future<void> killProcess(String pid) async {
    await Process.run('taskkill', ['/PID', pid, '/F']);

  }
}