import 'dart:io';

class Day2 {
  Day2() {
    print('Day 2 ....');
    readRPS().then(
        (score) => print('Rock Paper Scissors Score = ${score.toString()}'));
  }

  Future<List<int>> readRPS() async {
    List<int> lstRet = [0, 0];
    List<String> contents = await File('data/2-rps.txt').readAsLines();
    contents.forEach((element) {
      List<String> moves = element.split(' ');
      lstRet[0] += getPt1Scores(moves[0], moves[1]);
      lstRet[1] += getPt2Scores(moves[0], moves[1]);
    });
    return lstRet;
  }

  int getPt1Scores(String them, String me) {
    int choiceScore = (me == 'X' ? 1 : (me == 'Y' ? 2 : 3));
    String themChar = String.fromCharCode(them.codeUnitAt(0) + 23);
    String thePair = themChar + me;
    int matchScore = (me == themChar
        ? 3
        : ['ZX', 'YZ', 'XY'].contains(thePair)
            ? 6
            : 0);

    return (matchScore + choiceScore);
  }

  int getPt2Scores(String them, String outcome) {
    String myChoice = '';
    int matchScore = 0;

    if (outcome == 'Y') {
      matchScore = 3;
      myChoice = String.fromCharCode(them.codeUnitAt(0) + 23);
    }
    if (outcome == 'X') {
      //lose
      Map<String, String> loseChoices = new Map();
      loseChoices['A'] = 'Z';
      loseChoices['B'] = 'X';
      loseChoices['C'] = 'Y';
      myChoice = loseChoices[them].toString();
      matchScore = 0;
    }
    if (outcome == 'Z') {
      //win
      Map<String, String> winChoices = new Map();
      winChoices['A'] = 'Y';
      winChoices['B'] = 'Z';
      winChoices['C'] = 'X';
      myChoice = winChoices[them].toString();
      matchScore = 6;
    }

    int choiceScore = (myChoice == 'X' ? 1 : (myChoice == 'Y' ? 2 : 3));

    return (matchScore + choiceScore);
  }
}
