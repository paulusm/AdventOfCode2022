import 'dart:io';
import 'dart:math';
import 'dart:collection';

class Day25 {
  SplayTreeMap retMap = SplayTreeMap();

  Day25() {
    retMap.clear();
    getData().then((data) {
      int totSum = 0;
      for (String snafuNum in data) {
        //print('SNAFU - $snafuNum, Decimal - ${snafu2dec(snafuNum)}');
        totSum += snafu2dec(snafuNum);
      }
      print('total = $totSum');
      retMap = dec2snafu(totSum); //314159265
      doCarries();

      print('In SNAFU = ${retMap.values.toList().reversed.join()}');
      print('Expecting 2=-1=0');
    });
  }

  SplayTreeMap doCarries() {
    SplayTreeMap iterMap = SplayTreeMap();
    iterMap.addAll(retMap);
    for (int key in iterMap.keys) {
      switch (retMap[key]) {
        case '3':
          retMap[key] = '=';
          retMap.update(key * 5, (value) => (int.parse(value) + 1).toString(),
              ifAbsent: () => '1');
          break;
        case '4':
          retMap[key] = '-';
          retMap.update(key * 5, (value) => (int.parse(value) + 1).toString(),
              ifAbsent: () => '1');
          break;
        case '5':
          retMap[key] = '0';
          retMap.update(key * 5, (value) => (int.parse(value) + 1).toString(),
              ifAbsent: () => '1');
          break;
        default:
      }
    }
    return retMap;
  }

  SplayTreeMap dec2snafu(int theNumber) {
    int divisor = 1;

    //get the top divisor
    while (divisor * 5 < theNumber) {
      divisor *= 5;
    }

    int currentDigit =
        (theNumber < 5 ? theNumber : (theNumber / divisor).floor());

    if (currentDigit == 5) {
      retMap.update(divisor * 5, (value) => (int.parse(value) + 1).toString(),
          ifAbsent: () => '1');
      retMap.update(divisor, (value) => value, ifAbsent: () => '0');
    }
    if (currentDigit < 5) {
      retMap.update(
          divisor, (value) => (int.parse(value) + currentDigit).toString(),
          ifAbsent: () => currentDigit.toString());
    }

    int theRemainder = theNumber - currentDigit * divisor;

    if (divisor > 1) {
      retMap = dec2snafu(theRemainder);
    }

    return retMap;
  }

  int snafu2dec(String snafuNum) {
    List<String> snafDigits = snafuNum.split('');
    num val = 0;

    for (int i = 0; i < snafDigits.length; i++) {
      String currentString = snafDigits.reversed.toList()[i];
      int currentDigit = 0;
      if (currentString == '-') {
        currentDigit = -1;
      } else if (currentString == '=') {
        currentDigit = -2;
      } else {
        currentDigit = int.parse(currentString);
      }
      val += pow(5, i) * currentDigit;
    }

    return val.toInt();
  }

  Future<List<String>> getData() async {
    return File('data/25-snafu.txt').readAsLines();
  }
}
