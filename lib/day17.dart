import 'dart:io';
import 'package:matrices/matrices.dart';

class Day17 {
  Matrix chamber = Matrix.zero(10000, 7);
  int currentJet = 0;
  int startingRow = 9999 - 4;

  Day17() {
    readData().then((data) {
      List jets = data.split('');
      int currentJet = 0;
      Rock currentRock = LongHorizontal();
      int doLoop = 5;

      for (int i = 0; i < 5; i++) {
        switch (i) {
          case 0:
            currentRock = LongHorizontal();
            break;
          case 1:
            currentRock = Cross();
            break;
          case 2:
            currentRock = Angle();
            break;
          case 3:
            currentRock = LongVertical();
            break;
          case 4:
            currentRock = Small();
            break;
        }

        print(currentRock.runtimeType.toString());

        currentRock.bottomLeftPosition = [
          startingRow,
          currentRock.bottomLeftPosition[1]
        ];
        while (doLoop >= 0) {
          print(doLoop);
          //start of loop
          //print(jets[currentJet]);
          currentRock.bottomLeftPosition[1] += (jets[currentJet] == '>'
              ? (currentRock.bottomLeftPosition[1] + currentRock.width >= 7
                  ? 0
                  : 1)
              : (currentRock.bottomLeftPosition[1] == 0 ? 0 : -1));

          currentRock.bottomLeftPosition[0] += 1;
          //print(currentRock.bottomLeftPosition);
          doLoop--;
          if (currentRock.bottomLeftPosition[0] == 9999 ||
              isGrounded(currentRock)) {
            print('grounded!');
            doLoop = -1;
            // Mark the resting position of the rock on the grid
            for (int a = 0; a < currentRock.height; a++) {
              for (int b = 0; b < currentRock.width; b++) {
                chamber.matrix[currentRock.bottomLeftPosition[0] - a]
                    [currentRock.bottomLeftPosition[1] + b] = 1;
                //remove blank areas
                for (List empty in currentRock.emptyPositions) {
                  if (empty[0] == a && empty[1] == b) {
                    chamber.matrix[currentRock.bottomLeftPosition[0] - a]
                        [currentRock.bottomLeftPosition[1] + b] = 0;
                  }
                }
              }
            }

            //currentRock.height + 1;
          }
          currentJet++;
        }
        startingRow -= 1;
        doLoop = 5;
        printChamber();
      }

      printChamber();
    });
  }

  printChamber() {
    String chamberRow = '';
    for (int i = startingRow; i < 10000; i++) {
      chamberRow = '|';
      for (int j = 0; j < 7; j++) {
        chamberRow += (chamber.matrix[i][j] == 0 ? '.' : '#');
      }
      chamberRow += '|';
      print(chamberRow);
    }
    print('+-------+');
  }

  bool isGrounded(Rock theRock) {
    //print(theRock.bottomLeftPosition);
    if (chamber.matrix[theRock.bottomLeftPosition[0] + 1]
                [theRock.bottomLeftPosition[1]] ==
            1 ||
        chamber.matrix[theRock.bottomLeftPosition[0] + 1]
                [theRock.bottomLeftPosition[1] + theRock.width - 1] ==
            1) {
      return true;
    }
    return false;
  }

  Future<String> readData() async {
    return File('data/17-rockfall-test.txt').readAsString();
  }
}

class Rock {
  Rock(List blPos, List emptyPos, int width, int height)
      : bottomLeftPosition = blPos,
        emptyPositions = emptyPos,
        width = width,
        height = height {}
  List bottomLeftPosition;
  List emptyPositions;
  int width;
  int height;
}

class LongHorizontal extends Rock {
  LongHorizontal() : super([0, 2], [], 4, 1);
}

class LongVertical extends Rock {
  LongVertical() : super([0, 2], [], 1, 4);
}

class Cross extends Rock {
  Cross()
      : super([
          0,
          2
        ], [
          [0, 0],
          [2, 0],
          [0, 2],
          [2, 2]
        ], 3, 3);
}

class Angle extends Rock {
  Angle()
      : super([
          0,
          2
        ], [
          [0, 0],
          [0, 1],
          [1, 0],
          [1, 1]
        ], 3, 3);
}

class Small extends Rock {
  Small() : super([0, 2], [], 2, 2);
}
