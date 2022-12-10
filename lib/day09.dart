import 'dart:io';

import 'package:matrices/matrices.dart';

//Works on test dats, not on full data
// Far too hacky 😉

class Day9 {
  final int gridSize = 800;
  Matrix grid = Matrix();
  String lastMovePlane = 'horizontal';
  List<int> lastHeadPos = [0, 0];
  int steps = 0;

  Day9() {
    readData().then((data) {
      List<String> headMove;
      grid = Matrix.zero(gridSize, gridSize);
      List<int> headPos = [400, 400];
      List<int> tailPos = [400, 400];
      int movePremium = 0;

      for (String line in data) {
        lastHeadPos = headPos.toList();

        headMove = line.split(' ');
        switch (headMove[0]) {
          case 'R':
            headPos[0] += int.parse(headMove[1]) + movePremium;
            break;
          case 'U':
            headPos[1] += int.parse(headMove[1]) + movePremium;
            break;
          case 'L':
            headPos[0] -= int.parse(headMove[1]) + movePremium;
            break;
          case 'D':
            headPos[1] -= int.parse(headMove[1]) + movePremium;
            break;
        }
        movePremium = 0;
        tailPos = moveTail(headPos, tailPos);
        steps++;
        print(steps);
        //print(grid);
      }

      double totalMoves = 0;
      grid.matrix.forEach((gridRow) {
        totalMoves += gridRow.reduce((value, element) => value + element);
      });
      print('Total moves - $totalMoves');
      //print(grid);
    });
  }

  List<int> moveTail(List<int> lstHeadPos, List<int> lstTailPos) {
    List<int> difPos = [
      lstHeadPos[0] - lastHeadPos[0],
      lstHeadPos[1] - lastHeadPos[1]
    ];
    List<int> lstNewTailPos = lstTailPos;
    //print('from $lastHeadPos');
    //print('to $lstHeadPos');
    //print('Differential $difPos');

    String currentMovePlane = (difPos[0] != 0 ? 'horizontal' : 'vertical');

    bool planeChange = currentMovePlane != lastMovePlane;
    //print(planeChange);
    lastMovePlane = currentMovePlane;

    // Make a trail
    for (int i in Iterable.generate(difPos[0].abs())) {
      //print('move x - $i');
      int j = (difPos[0] < 0 ? -1 * i : i);
      lstNewTailPos = [
        lstTailPos[0] + (i == 0 && planeChange ? 0 : j),
        (i > 0 || !planeChange ? lstHeadPos[1] : lstTailPos[1])
      ];
      if (lstNewTailPos[0] == lstHeadPos[0]) {
        lstNewTailPos[0] = lstNewTailPos[0] + (difPos[0] < 0 ? 1 : -1);
      }
      //print(lstNewTailPos);
      grid.matrix[lstNewTailPos[0]][lstNewTailPos[1]] = 1;
    }

    for (int i in Iterable.generate(difPos[1].abs())) {
      //print('move y - $i');
      int j = (difPos[1] < 0 ? -1 * i : i);
      lstNewTailPos = [
        (i > 0 || !planeChange ? lstHeadPos[0] : lstTailPos[0]),
        lstTailPos[1] + (i == 0 && planeChange ? 0 : j)
      ];
      if (lstNewTailPos[1] == lstHeadPos[1]) {
        lstNewTailPos[1] = lstNewTailPos[1] + (difPos[0] < 0 ? 1 : -1);
      }
      grid.matrix[lstNewTailPos[0]][lstNewTailPos[1]] = 1;
    }

    print('head at $lstHeadPos, tail at $lstNewTailPos');
    return lstNewTailPos;
  }

  Future<List<String>> readData() async {
    return (await File('data/9-rope.txt').readAsLines());
  }
}
