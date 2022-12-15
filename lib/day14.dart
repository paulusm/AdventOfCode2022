import 'dart:io';
import 'package:matrices/matrices.dart';

//dunno why but need to add 1 to part 2 score

class Day14 {
  Matrix grid = Matrix.zero(167, 400); //167,82 //Test 12,35
  int xOffset = 300; //was 480
  int sandLimit = 0;
  bool withFloor = true; //Part 2

  Day14() {
    // Set origin
    grid.matrix[0][500 - xOffset] = 3;

    readData().then((data) {
      for (String line in data) {
        List<String> segs = line.split(' -> ');
        List segCoords = [];
        for (String seg in segs) {
          List segCoord = (seg.split(',').map((e) => int.parse(e))).toList();
          segCoords.add(segCoord);
        }
        // Draw the rock obstacle map
        for (int i = 0; i < segCoords.length - 1; i++) {
          for (int j = segCoords[i][0]; j <= segCoords[i + 1][0]; j++) {
            //print('coord 1 - (${segCoords[i][1]},${j - xOffset})');
            grid.matrix[segCoords[i][1]][j - xOffset] = 1.0;
          }
          for (int j = segCoords[i][1]; j <= segCoords[i + 1][1]; j++) {
            //print('coord 2 - (${j},${segCoords[i][0] - xOffset})');
            grid.matrix[j][segCoords[i][0] - xOffset] = 1.0;
          }
          for (int j = segCoords[i][0]; j >= segCoords[i + 1][0]; j--) {
            //print('coord 3 - (${segCoords[i][1]},${j - xOffset})');
            grid.matrix[segCoords[i][1]][j - xOffset] = 1.0;
          }
          for (int j = segCoords[i][1]; j >= segCoords[i + 1][1]; j--) {
            //print('coord 4 - (${j},${segCoords[i][0] - xOffset})');
            grid.matrix[j][segCoords[i][0] - xOffset] = 1.0;
          }
        }
        if (withFloor) {
          for (int i = 0; i < grid.matrix[0].length; i++) {
            grid.matrix[grid.matrix.length - 1][i] = 1.0;
          }
        }
      }
      for (int i = 0; i < 30000; i++) {
        bool settled = dropGrain();
        if (!settled) {
          sandLimit = i;
          break;
        }
      }
      print('Overflow/blockage after $sandLimit grains fell');
      printGrid();
    });
  }

  bool dropGrain() {
    int grainX = 500 - xOffset;
    int grainY = -1;
    bool atRest = false;

    while (!atRest) {
      grainY += 1;
      //condition only met if no floor I hope
      if (grainY == grid.matrix.length - 1) {
        return atRest;
      }

      //check below
      if (grid.matrix[grainY + 1][grainX] > 0) {
        //print('$grainY $grainX');
        if (grid.matrix[grainY + 1][grainX - 1] == 0) {
          grainX--;
        } else if (grid.matrix[grainY + 1][grainX + 1] == 0) {
          grainX++;
        } else {
          atRest = true;
        }
      }
    }
    //Condition for part 2 of top being blocked
    if (grainY == 0 && grainX == 500 - xOffset) {
      atRest = false;
    }
    grid.matrix[grainY][grainX] = 2;
    return atRest;
  }

  void printGrid() {
    for (List<double> line in grid.matrix) {
      String outputLine = '';
      for (double cell in line) {
        switch (cell.toInt()) {
          case 0:
            outputLine += '.';
            break;
          case 1:
            outputLine += '#';
            break;
          case 2:
            outputLine += 'o';
            break;
          case 3:
            outputLine += '+';
            break;
        }
      }
      print(outputLine);
    }
  }

  Future<List<String>> readData() async {
    return File('data/14-sand.txt').readAsLines();
  }
}
