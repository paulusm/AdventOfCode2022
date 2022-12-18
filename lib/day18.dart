import 'dart:io';

class Day18 {
  List<List<int>> lavaList = [];
  Day18() {
    int exposedFaces = 0;
    readData().then((data) {
      for (String line in data) {
        lavaList.add(line.split(',').map((e) => int.parse(e)).toList());
      }
      List possAbutments = [
        [0, 0, 1],
        [0, 0, -1],
        [1, 0, 0],
        [-1, 0, 0],
        [0, 1, 0],
        [0, -1, 0]
      ];
      for (List cube in lavaList) {
        int openFaces = 6;
        for (List possAbutment in possAbutments) {
          if (lavaContains([
            cube[0] + possAbutment[0],
            cube[1] + possAbutment[1],
            cube[2] + possAbutment[2]
          ])) {
            openFaces--;
          }
        }
        exposedFaces += openFaces;
      }

      print('Exposed faces - $exposedFaces');
    });
  }

  bool lavaContains(List targetCube) {
    for (List cube in lavaList) {
      bool isEqual = true;
      for (int i = 0; i < 3; i++) {
        if (targetCube[i] != cube[i]) {
          isEqual = false;
        }
      }
      if (isEqual) {
        return true;
      }
    }
    return false;
  }

  Future<List<String>> readData() async {
    return File('data/18-cubes.txt').readAsLines();
  }
}
