import 'dart:io';
import 'elf.dart';

class Day1 {
  List<Elf> _elfList;

  Day1() : _elfList = [] {
    print("Day 1 ....");
    loadCals().then((numLoaded) {
      print(' ${numLoaded} elves loaded!');
      print('most cals for one elf ${maxCals()}!');
      print('calories of top 3 elves ${top3Cals()}!');
      print('');
    });
  }

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

  int top3Cals() {
    _elfList.sort((oneElf, totherElf) {
      return totherElf.totalCals().compareTo(oneElf.totalCals());
    });
    // For some reason, need to register the first element by forcing it 😮
    return [0, 0, 1, 2].reduce((value, element) {
      //print(value + _elfList[element].totalCals());
      return value + _elfList[element].totalCals();
    });
  }

  void printTop() {
    print(_elfList[0].totalCals() +
        _elfList[1].totalCals() +
        _elfList[2].totalCals());
  }
}
