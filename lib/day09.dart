import 'dart:io';

import 'package:matrices/matrices.dart';

class Day9 {
  final int gridSize = 6;
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
      }

      double totalMoves = 0;
      grid.matrix.forEach((gridRow) {
        totalMoves += gridRow.reduce((value, element) => value + element);
      });
      print('Total moves - $totalMoves');
      print(grid);
    });
  }

  List<int> moveTail(List<int> lstHeadPos, List<int> lstTailPos) {
    List<int> difPos = [
      lstHeadPos[0] - lastHeadPos[0],
      lstHeadPos[1] - lastHeadPos[1]
    ];
    List<int> lstNewTailPos = lstTailPos;
    print('from $lastHeadPos');
    print('to $lstHeadPos');
    print('Differential $difPos');

    String currentMovePlane = (difPos[0] != 0 ? 'horizontal' : 'vertical');

    bool planeChange = currentMovePlane != lastMovePlane;

    // Make a trail
    for (int i in Iterable.generate(difPos[0].abs())) {
      print('move x - $i');
      int j = (difPos[0] < 0 ? i * -1 : i);
      grid.matrix[lstTailPos[0] + j][lstTailPos[1]] = 1;
      lstNewTailPos = [
        lstTailPos[0] + (i == 1 && planeChange ? 0 : j),
        (i > 1 ? lstHeadPos[1] : lstTailPos[1])
      ];
    }

    for (int i in Iterable.generate(difPos[1].abs())) {
      print('move y - $i');
      int j = (difPos[1] < 0 ? i * -1 : i);
      grid.matrix[lstTailPos[0]][lstTailPos[1] + j] = 1;
      lstNewTailPos = [
        (i > 1 ? lstHeadPos[0] : lstTailPos[0]),
        lstTailPos[1] + (i == 1 && planeChange ? 0 : j)
      ];
    }

    print('head at $lstHeadPos, tail at $lstNewTailPos');
    return lstNewTailPos;
  }

  Future<List<String>> readData() async {
    return (await File('data/9-rope-test.txt').readAsLines());
  }
}
