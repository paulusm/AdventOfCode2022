import 'dart:io';

class Day15 {
  List features = [];
  //4595700 too low (when not including -x)
  //5175627 too high 🤔
  Day15() {
    readData().then((data) {
      RegExp dataMatch = RegExp(
          r'Sensor at x=(-*\d+), y=(-*\d+): closest beacon is at x=(-*\d+), y=(-*\d+)');
      for (String line in data) {
        RegExpMatch? matchResults = dataMatch.firstMatch(line);
        if (matchResults != null) {
          features.add([
            [
              int.parse(matchResults[1] ?? ''),
              int.parse(matchResults[2] ?? '')
            ],
            [int.parse(matchResults[3] ?? ''), int.parse(matchResults[4] ?? '')]
          ]);
        }
      }
      //print(features);
      print('Points ruled out - ${getCoverageForLine(2000000)}');
    });
  }

  int getCoverageForLine(int lineNo) {
    int currentDistance = 0;
    Set pointsCovered = {};

    for (List sensorBeaconPair in features) {
      //Get distance from one another
      currentDistance =
          getManhattanDist(sensorBeaconPair[0], sensorBeaconPair[1]);
      //print('Current Pair distance is - $currentDistance');

      //Get overlaps for each poin in the line
      for (int i = -1000000; i < 5000001; i++) {
        //for (int i = -10; i < 30; i++) {
        int pointDistance = getManhattanDist(sensorBeaconPair[0], [lineNo, i]);
        if (pointDistance <= currentDistance) {
          pointsCovered.add(i);
        }
      }
    }

    //print(pointsCovered);
    return pointsCovered.length - 1;
  }

  int getManhattanDist(List a, List b) {
    return (a[0] - b[0]).abs() + (a[1] - b[1]).abs();
  }

  Future<List<String>> readData() async {
    return File('data/15-beacon.txt').readAsLines();
  }
}
