import 'dart:io';
import 'package:matrices/matrices.dart';

class Day14 {
  Matrix grid = Matrix.zero(165, 80); //165,80 //Test 15,30
  int xOffset = 480;

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
      }
      printGrid();
    });
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
