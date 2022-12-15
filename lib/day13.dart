import 'dart:io';
import 'dart:convert';

//3227 is too low;
//5754 it too high;
//not 5709
// not 5710
// not 5711

// [[], 10, [[4, 7], [], 3, 6], [[8, 3, 8], [1], 3, [9]]] v [[]]
// [] v []
// Comparison.correct

enum Comparison { correct, incorrect, undecided }

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
        //pairs.length //
        print(i);
        Comparison overallComp =
            comparePairs([jsonDecode(pairs[i][0]), jsonDecode(pairs[i][1])]);
        print(overallComp);
        if (overallComp == Comparison.undecided) {
          throw ('Undecided was returned');
        }
        if (overallComp == Comparison.correct) {
          rightOrder += (i + 1);
        }
      }
      print('Sum of indices - $rightOrder');
    });
  }

  Comparison comparePairs(List pairs) {
    List left = pairs[0];
    List right = pairs[1];
    print('$left v $right');
    if (left.isEmpty && !right.isEmpty) {
      return Comparison.correct;
    }
    for (int i = 0; i < left.length; i++) {
      if (i > right.length - 1) return Comparison.incorrect;
      if (left[i].runtimeType.toString() == 'List<dynamic>' ||
          right[i].runtimeType.toString() == 'List<dynamic>') {
        if (right[i].runtimeType.toString() == 'int') {
          right[i] = [right[i]];
        }
        if (left[i].runtimeType.toString() == 'int') {
          left[i] = [left[i]];
        }

        Comparison subComp = comparePairs([left[i], right[i]]);
        print('recurse - $subComp');
        if (subComp != Comparison.undecided) return (subComp);
      } else {
        if (left[i] > right[i]) {
          return Comparison.incorrect;
        }
        if (left[i] < right[i] ||
            (left[i] == right[i] && i == left.length - 1)) {
          return Comparison.correct;
        }
      }
    }
    return Comparison.undecided;
  }

  Future<List<String>> readData() async {
    return File('data/13-distress.txt').readAsLines();
  }
}
