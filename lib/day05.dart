import 'dart:io';

class Day5 {
  Day5() {
    readData().then((data) {
      List<List<String>> crates = [[], [], [], [], [], [], [], [], []];
      for (int i = 7; i >= 0; i--) {
        //print(data[i]);
        int crateCounter = 0;
        for (int j = 1; j < 34; j += 4) {
          String crateCode = data[i].substring(j, j + 1);
          if (crateCode != ' ') crates[crateCounter].add(crateCode);
          crateCounter++;
        }
        //[Z] [Q] [F] [L] [G] [W] [H] [F] [M]
        //2,6,10,etc
      }
      //print(crates.toString());
      for (int i = 10; i < 511; i++) {
        //511
        RegExp exp = RegExp(r'(\d+)');
        Iterable<RegExpMatch> matches = exp.allMatches(data[i]);
        int moveNumber = int.parse((matches.elementAt(0)[0]).toString());
        int moveFrom = int.parse((matches.elementAt(1)[0]).toString()) - 1;
        int moveTo = int.parse((matches.elementAt(2)[0]).toString()) - 1;
        //for (int j = 0; j < moveNumber; j++) {
        crates[moveTo].addAll(
            crates[moveFrom].sublist(crates[moveFrom].length - moveNumber));
        crates[moveFrom].removeRange(
            crates[moveFrom].length - moveNumber, crates[moveFrom].length);
        //}
      }
      for (int i = 0; i < 9; i++) {
        print(crates[i].last);
      }
    });
  }

  Future<List<String>> readData() async {
    return (await File('data/5-stacks.txt').readAsLines());
  }
}
