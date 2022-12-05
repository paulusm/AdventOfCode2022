import 'dart:io';
import 'elf.dart';

class Advent {
  List<Elf> _elfList;

  Advent() : _elfList = [];

  Future<int> loadCals() async {
    Elf currentElf = Elf([]);

    List<String> contents = await File('data/cals.txt').readAsLines();

    contents.forEach((element) {
      if (element == '' || _elfList.isEmpty) {
        currentElf = Elf([]);
        _elfList.add(currentElf);
      } else {
        currentElf.calories.add(int.parse(element));
      }
      //throw ('No Elves Loaded!');
    });
    return _elfList.length;
  }

  int maxCals() {
    Elf maxElf = _elfList.reduce((value, element) {
      if (element.totalCals() > value.totalCals()) {
        return element;
      } else {
        return value;
      }
    });
    return (maxElf.totalCals());
  }
}
