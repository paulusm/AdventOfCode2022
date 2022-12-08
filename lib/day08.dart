import 'dart:io';

import 'package:matrices/matrices.dart';

class Day8 {
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
      print(dataList.length);
      print(dataList[0].length);
      Matrix grid = Matrix.fromList(dataList);
      print(grid.matrix[0][98]);
    });
  }

  Future<List<String>> readData() async {
    return (await File('data/8-trees.txt').readAsLines());
  }
}
