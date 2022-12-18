import 'dart:io';

//Part 2, 3402 is too high
// Airpockets may be larger than 1 cube..?

class Day18 {
  List<List<int>> lavaList = [];
  List<List<int>> candidateAirSpaces = [];
  Day18() {
    int exposedFaces = 0;
    int airPockets = 0;
    readData().then((data) {
      for (String line in data) {
        lavaList.add(line.split(',').map((e) => int.parse(e)).toList());
      }

      for (List cube in lavaList) {
        exposedFaces += countAbutments(cube);
      }

      for (List airSpace in candidateAirSpaces.toList()) {
        int enclosures = countAbutments(airSpace);
        if (enclosures == 0) {
          print(airSpace);
          airPockets++;
        }
      }

      print('Exposed faces - $exposedFaces');
      print('Air pockets  - $airPockets');
      print('Exterior faces - ${exposedFaces - (airPockets * 6)}');
    });
  }

  int countAbutments(List cube) {
    List possAbutments = [
      [0, 0, 1],
      [0, 0, -1],
      [1, 0, 0],
      [-1, 0, 0],
      [0, 1, 0],
      [0, -1, 0]
    ];
    int openFaces = 6;

    for (List possAbutment in possAbutments) {
      List<int> cubeToAssess = [
        cube[0] + possAbutment[0],
        cube[1] + possAbutment[1],
        cube[2] + possAbutment[2]
      ];
      if (listContains(lavaList, cubeToAssess)) {
        openFaces--;
      } else {
        if (listContains(candidateAirSpaces, cubeToAssess) == false) {
          candidateAirSpaces.add(cubeToAssess);
        }
      }
    }
    return openFaces;
  }

  bool listContains(List cubeList, List targetCube) {
    for (List cube in cubeList) {
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
