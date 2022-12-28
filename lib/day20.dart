import 'dart:io';
import 'dart:math';
import 'dart:collection';

//5081 too low doh

class Day20 {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  Day20() {
    readData().then((data) {
      // List<String> sequence =
      //     data.map((e) => '${getRandomString(5)}|$e').toList();
      List<String> sequence =
          [1, 2, -3, 3, 4, 0].map((e) => '${getRandomString(5)}|$e').toList();

      List<String> seqout = sequence.toList();

      int listLen = sequence.length;
      String zeroKey = '';

      for (int i = 0; i < listLen; i++) {
        //Get the current pos of that element
        int elPos = seqout.indexWhere((element) => element == sequence[i]);

        //remove element and see how to move it
        seqout.removeAt(elPos);
        int offSet = int.parse(sequence[i].split('|')[1]);

        //store the key for the 0
        if (offSet == 0) zeroKey = sequence[i];

        // get insertion point (minus 1 if moving left, plus one if wrapping)
        //(offSet < 0 ? offSet - 1 : offSet))
        int insPos = (elPos + (offSet < 0 ? offSet - 1 : offSet)) % listLen;
        if (insPos < offSet) insPos++;
        seqout.insert(insPos, sequence[i]);

        print(stripIDs(seqout));
      }

      print(stripIDs(seqout));

      int zeroPos = seqout.indexWhere((element) => element == zeroKey);
      print('zero at - $zeroPos');

      List msgList = stripIDs([1000, 2000, 3000]
          .map((e) => seqout[(e + zeroPos) % listLen])
          .toList());

      print(msgList);
      print(msgList
          .map((e) => int.parse(e))
          .reduce((value, element) => value + element));
    });
  }

  Future<List<String>> readData() async {
    return File('data/20-grove.txt').readAsLines();
  }

  List<String> stripIDs(List<String> inList) {
    return inList.map((e) => e.split('|')[1]).toList();
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
