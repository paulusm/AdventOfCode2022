import 'dart:io';

class Day16 {
  Day16() {
    readData().then((data) {
      RegExp dataMatch = RegExp(
          r'Valve (\S\S) has flow rate=(\d+); tunnels lead to valves (.*)');
      for (String line in data) {
        RegExpMatch? matchResults = dataMatch.firstMatch(line);
        if (matchResults != null) {
          print(matchResults[1]);
          print(matchResults[2]);
          print(matchResults[3]);
        }
      }
    });
  }

  Future<List<String>> readData() async {
    return File('data/16-valves-test.txt').readAsLines();
  }
}
