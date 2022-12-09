import 'dart:io';

import 'package:matrices/matrices.dart';

class Day9 {
  final int gridSize = 30;
  Matrix grid = Matrix();
  String lastMovePlane = 'horizontal';
  List<int> lastHeadPos = [0, 0];

  Day9() {
    readData().then((data) {
      List<String> headMove;
      grid = Matrix.zero(gridSize, gridSize);
      List<int> headPos = [0, 0];
      List<int> tailPos = [0, 0];

      for (String line in data) {
        lastHeadPos = headPos.toList();

        headMove = line.split(' ');
        switch (headMove[0]) {
          case 'R':
            headPos[0] += int.parse(headMove[1]) + 1;
            break;
          case 'U':
            headPos[1] += int.parse(headMove[1]) + 1;
            break;
          case 'L':
            headPos[0] -= int.parse(headMove[1]) + 1;
            break;
          case 'D':
            headPos[1] -= int.parse(headMove[1]) + 1;
            break;
        }

        tailPos = moveTail(headPos, tailPos);
        //print('head at $headPos, tail at $tailPos');
      }
      print(grid);
    });
  }

  List<int> moveTail(List<int> lstHeadPos, List<int> lstTailPos) {
    List<int> difPos = [
      lstHeadPos[0] - lastHeadPos[0],
      lstHeadPos[1] - lastHeadPos[1]
    ];
    print('from $lastHeadPos');
    print('to $lstHeadPos');
    print('Differential $difPos');

    String currentMovePlane = (difPos[0] != 0 ? 'horizontal' : 'vertical');

    print('plane change? ${currentMovePlane != lastMovePlane}');

    List<int> lstNewTailPos = [
      lstTailPos[0] + (difPos[0] == 0 ? 0 : lstTailPos[0] + difPos[0] - 1),
      lstTailPos[1] + (difPos[1] == 0 ? 0 : lstTailPos[1] + difPos[1] - 1)
    ];

    print('head at $lstHeadPos, tail at $lstNewTailPos');

    grid.matrix[lstNewTailPos[0]][lstNewTailPos[1]] = 1;

    return lstNewTailPos;
  }

  Future<List<String>> readData() async {
    return (await File('data/9-rope-test.txt').readAsLines());
  }
}
