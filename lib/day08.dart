import 'dart:io';

import 'package:matrices/matrices.dart';

class Day8 {
  Matrix grid = Matrix();
  int scenicScore = 0;

  Day8() {
    readData().then((data) {
      List<List<double>> dataList = [];

      for (String line in data) {
        List<String> oneStringRow = line.split('');
        List<double> oneRow = [];
        for (String digit in oneStringRow) {
          oneRow.add(double.parse(digit));
        }
        //print(oneRow.length);
        dataList.add(oneRow);
      }

      grid = Matrix.fromList(dataList);
      int numVisible = 0;
      for (int x = 0; x < grid.matrix.length; x++) {
        for (int y = 0; y < grid.matrix.length; y++) {
          numVisible += checkVisible(x, y);
        }
      }
      print('Visble trees = $numVisible');
      print('Max Scenic Score = $scenicScore');
    });
  }

  int checkVisible(x, y) {
    List<bool> compass = [true, true, true, true];
    if (x == 0 ||
        y == 0 ||
        x == grid.matrix.length - 1 ||
        y == grid.matrix.length - 1) {
      //print('perimeter');
      return 1;
    }

    int cardCounter = 0;
    List<int> scenicScores = [0, 0, 0, 0];

    for (List cardinal in [
      [1, 0],
      [0, 1],
      [-1, 0],
      [0, -1]
    ]) {
      int a = x;
      int b = y;

      while (a > 0 &&
          a < grid.matrix.length - 1 &&
          b > 0 &&
          b < grid.matrix.length - 1) {
        a += cardinal[0] as int;
        b += cardinal[1] as int;

        scenicScores[cardCounter] += 1;

        if (grid.matrix[a][b] >= grid.matrix[x][y]) {
          compass[cardCounter] = false;
          break;
        }
      }
      cardCounter++;
    }

    int treeScenicScore =
        scenicScores[0] * scenicScores[1] * scenicScores[2] * scenicScores[3];
    if (treeScenicScore > scenicScore) {
      scenicScore = treeScenicScore;
    }
    //print(compass);
    if (compass.join() == [false, false, false, false].join()) {
      //print('invis');
      return 0;
    } else {
      //tree is viz
      //print('gotcha!');
      return 1;
    }
  }

  Future<List<String>> readData() async {
    return (await File('data/8-trees.txt').readAsLines());
  }
}
