import 'dart:io';
import 'dart:mirrors';
import 'package:matrices/matrices.dart';

//Development paused due to lack of brain cells
// CONTRIBUTE! Send me some brain cells pls

class Day12 {
  Matrix grid = Matrix();
  List<int> home = [];
  List<int> top = [];

  Day12() {
    readData().then((data) {
      List<List<double>> matrixSource = [];
      for (String line in data) {
        List<String> currentLine = line.split('');
        List<double> matrixLine = [];
        for (String cell in currentLine) {
          //convert to ascii codes with a at 0
          double charVal = cell.codeUnitAt(0).toDouble() - 97;
          if (charVal == -14) {
            charVal = -1;
            // get origin (starting pos)
            home = [data.indexOf(line), currentLine.indexOf(cell)];
          }
          // get destination
          if (charVal == -28) {
            charVal = 99;
            top = [data.indexOf(line), currentLine.indexOf(cell)];
          }
          matrixLine.add(charVal);
        }
        matrixSource.add(matrixLine);
      }

      grid = Matrix.fromList(matrixSource);
      //print(grid);
      print('Starting at $home');
      print('Heading for $top');
      print('Min steps - ${solve(grid)}');
    });
  }

  int solve(Matrix grid) {
    int steps = 1;
    int distance;
    List currentPos = home;
    List<List<int>> possMoves = [
      [0, 1],
      [1, 0],
      [-1, 0],
      [0, -1]
    ];
    while (currentPos != top) {
      print('\n*****Step $steps');
      print('at $currentPos');
      List<List<int>> candidateMoves = [];
      for (List<int> move in possMoves) {
        List<int> assessMove = [
          currentPos[0] + move[0],
          currentPos[1] + move[1]
        ];

        if (!assessMove.contains(-1) &&
            assessMove[0] < grid.matrix.length &&
            assessMove[1] < grid.matrix[0].length) {
          if (getHeightGain(currentPos, assessMove) < 2) {
            candidateMoves.add(assessMove);
          }
        }
      }
      print('Possible moves - $candidateMoves');
      int bestScore = -10000;
      List<int> bestMove = [];
      for (List<int> move in candidateMoves) {
        print('Possible move - $move');
        print('height gain - ${getHeightGain(currentPos, move)}');
        print('distance to step up - ${distanceToNearestStepUp(move)}');
        print('distance to top - ${getDistance(top, currentPos)}');
        int elScore = getHeightGain(currentPos, move); //* 2 +
        //distanceToNearestStepUp(move) *
        // (distanceToNearestStepUp(move) == 100000 ? 1 : -1) +
        // getDistance(move, top) * -1;
        print('total value of position $elScore');
        if (elScore > bestScore) {
          bestScore = elScore;
          bestMove = move;
        }
      }
      currentPos = bestMove;
      print('Best move - $bestMove');
      if (grid.matrix[currentPos[0]][currentPos[1]] == 25) {
        //Made it!
        print('***** GOT TO TOP ******');
        currentPos = top;
      }
      steps++;

      if (steps > 50) break;
    }

    return (steps);
  }

  int getDistance(from, to) {
    return (from[0] - to[0]).abs() + (from[1] - to[1]).abs();
  }

  int distanceToNearestStepUp(from) {
    double targetLevel = grid.matrix[from[0]][from[1]] + 1;
    int rowNo = -1;
    int minDistance = 100000;
    //inefficient but meh
    for (List<double> row in grid.matrix) {
      rowNo++;
      int foundCell = 0;
      int startFrom = 0;
      while (foundCell != -1) {
        foundCell = row.indexOf(targetLevel, startFrom);
        if (foundCell != -1) {
          int foundCellDistance =
              (from[0] - rowNo).abs() + (from[1] - foundCell).abs();
          //print('found cell $foundCell, distance $foundCellDistance');
          if (foundCellDistance < minDistance) {
            minDistance = foundCellDistance;
          }
          startFrom = foundCell + 1;
        }
      }
    }
    return minDistance;
  }

  int getHeightGain(from, to) {
    return (grid.matrix[to[0]][to[1]] - grid.matrix[from[0]][from[1]]).toInt();
  }

  Future<List<String>> readData() async {
    return (await File('data/12-hill.txt').readAsLines());
  }
}
