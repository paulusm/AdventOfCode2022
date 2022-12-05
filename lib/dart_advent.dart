import 'dart:io';
import 'elf.dart';

class Advent {
  List<Elf> _elfList;

  Advent() : _elfList = [];

  void loadCals() {
    Elf currentElf = Elf([]);

    File('data/cals.txt').readAsLines().then((List<String> contents) {
      contents.forEach((element) {
        if (element == '' || _elfList.isEmpty) {
          currentElf = Elf([]);
          _elfList.add(currentElf);
        } else {
          currentElf.calories.add(int.parse(element));
        }
      });
      print('${_elfList.length} elves added!');
    });
  }
}
