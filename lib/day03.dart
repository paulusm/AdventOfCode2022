import 'dart:io';

class Day3 {
  Day3() {
    openSacks().then((data) {
      int Score = 0;
      data.forEach((String items) {
        double lenItems = items.length.toDouble();
        int halfway = (lenItems ~/ 2).toInt();
        String compt1 = items.substring(0, halfway);
        String compt2 = items.substring(halfway);
        Set<String> comptList1 = compt1.split('').toSet();
        Set<String> comptList2 = compt2.split('').toSet();
        String overLap = comptList1.intersection(comptList2).first;
        //Scoring using ASCII Codes
        int overLapCode = overLap.codeUnitAt(0);
        Score += (overLapCode > 96 ? overLapCode - 96 : overLapCode - 38);
      });
      print('Score of overlapping items - $Score');

      int numGroups = data.length;
      int Score2 = 0;

      for (int i = 0; i < numGroups; i += 3) {
        Set<String> membList1 = data[i].split('').toSet();
        Set<String> membList2 = data[i + 1].split('').toSet();
        Set<String> membList3 = data[i + 2].split('').toSet();
        String commonChar =
            membList1.intersection(membList2).intersection(membList3).first;
        int overLapCode = commonChar.codeUnitAt(0);
        Score2 += (overLapCode > 96 ? overLapCode - 96 : overLapCode - 38);
      }
      print('Score for teams of 3 - $Score2');
    });
  }

  Future<List<String>> openSacks() async {
    return (await File('data/3-rucksack.txt').readAsLines());
  }
}
