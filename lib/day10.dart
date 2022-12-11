import 'dart:collection';
import 'dart:io';

class Day10 {
  Day10() {
    int x = 1;
    int output = 0;
    List<int> checkPoints = [40, 80, 120, 160, 200, 240];
    List<String> crtLines = [];
    Queue instructions = Queue();
    readData().then((data) {
      String currentCrtLine = '';
      List<String> cmd = [];
      HashMap instruction;

      data.forEach((execLine) {
        cmd = execLine.split(' ');
        instruction = HashMap();
        instruction['command'] = cmd[0];
        instruction['data'] = (cmd.length == 2 ? cmd[1] : '');
        instruction['started'] = 0;
        instructions.add(instruction);
      });

      for (int cycle = 1; cycle < 241; cycle++) {
        ((x - currentCrtLine.length).abs() <= 1
            ? currentCrtLine += '#'
            : currentCrtLine += '.');

        if (checkPoints.contains(cycle)) {
          crtLines.add(currentCrtLine);
          currentCrtLine = '';
          //print('At $cycle , x=$x value=${cycle * x}');
          output += cycle * x;
        }

        instruction = instructions.first;
        if (instruction['command'] == 'noop') {
          instructions.removeFirst();
        }
        if (instruction['command'] == 'addx') {
          switch (instruction['started']) {
            case 0:
              instruction['started'] = 1;
              break;
            case 1:
              x += int.parse(instruction['data']);
              instructions.removeFirst();
          }
        }
      }
      print('output - $output');
      for (String line in crtLines) {
        print(line);
      }
    });
  }

  Future<List<String>> readData() async {
    return (await File('data/10-register.txt').readAsLines());
  }
}
