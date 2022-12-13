import 'dart:io';
import 'dart:convert';

class Day13 {
  Day13() {
    readData().then((data) {
      List pairs = [];
      List newPair = [];
      int rightOrder = 0;
      for (String line in data) {
        if (line == '') {
          pairs.add(newPair);
          newPair = [];
        } else {
          newPair.add(line);
        }
      }
      pairs.add(newPair);

      for (int i = 0; i < pairs.length; i++) {
        if (comparePairs(pairs[i])) {
          rightOrder += i;
        }
      }
      print('Sum of indices - $rightOrder');
    });
  }

  bool comparePairs(List pairs) {
    return true;
  }

  Future<List<String>> readData() async {
    return File('data/13-distress-test.txt').readAsLines();
  }
}
