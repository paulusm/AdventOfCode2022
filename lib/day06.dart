import 'dart:io';

class Day6 {
  Day6() {
    readData().then((data) {
      //String test = 'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw'; //answer = 11
      //data = 'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw'; //11,26
      List<String> candidatePkt = [];

      int stringLen = 4;

      for (int i = 1; i < data.length; i++) {
        String theLetter = data.substring(i, i + 1);
        if (!candidatePkt.contains(theLetter)) {
          candidatePkt.add(theLetter);
        } else {
          i = i - candidatePkt.length;
          candidatePkt.clear();
        }
        //print(candidatePkt);
        if (candidatePkt.length == stringLen) {
          //print(candidatePkt.toString());
          print('Appears after ${i + 1}');
          stringLen = 14;
          candidatePkt.clear();
        }
      }
    });
  }

  Future<String> readData() async {
    return (await File('data/6-buffer.txt').readAsString());
  }
}
