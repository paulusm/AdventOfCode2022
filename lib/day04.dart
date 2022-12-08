import 'dart:io';

class Day4 {
  Day4() {
    int contained = 0;
    int overlapped = 0;
    openPairs().then((pairs) {
      for (String pair in pairs) {
        //.getRange(0, 3)
        List<String> twoPair = pair.split(',');
        List<int> firstList = [
          int.parse(twoPair[0].split('-')[0]),
          int.parse(twoPair[0].split('-')[1])
        ];
        List<int> secondList = [
          int.parse(twoPair[1].split('-')[0]),
          int.parse(twoPair[1].split('-')[1])
        ];
        if ((firstList[0] >= secondList[0] && firstList[1] <= secondList[1]) ||
            (firstList[0] <= secondList[0] && firstList[1] >= secondList[1])) {
          contained += 1;
        }
        //9-70,5-10 0 > 0; 1 > 1 but 0 < 1

        if ((firstList[0] < secondList[0] &&
                firstList[1] < secondList[1] &&
                firstList[1] >= secondList[0]) ||
            (firstList[1] > secondList[1] &&
                firstList[0] > secondList[0] &&
                firstList[1] <= secondList[0])) {
          overlapped += 1;
        }
      }
      print('$contained wholly contained sequences');
      print('${overlapped + contained} overlapped sequences');
    });
  }

  Future<List<String>> openPairs() async {
    return (await File('data/4-pairs.txt').readAsLines());
  }
}
