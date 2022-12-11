import 'dart:io';
import 'dart:collection';

class Day11 {
  LinkedHashMap monkeys = LinkedHashMap();
  int monkeyCount = 0;
  List<String> monkeysRaw = [];

  Day11() {
    readData().then((data) {
      monkeysRaw = data.split('Monkey ');
      monkeysRaw.removeAt(0);
      RegExp reItems = RegExp(r'Starting items: (.*)');
      RegExp reOp = RegExp(r'Operation: new = old (.) (.*)');
      RegExp reTest = RegExp(r'Test: divisible by ([0-9]+)');
      RegExp reTrue = RegExp(r'If true: throw to monkey.*([0-9]+)');
      RegExp reFalse = RegExp(r'If false: throw to monkey.*([0-9]+)');
      for (String monkeyRaw in monkeysRaw) {
        List monkeyItems = List.empty(growable: true);
        monkeyItems = (reItems.firstMatch(monkeyRaw)?.group(1) ?? '')
            .split(',')
            .map(int.parse)
            .toList(growable: true);
        List<String> monkeyOp = [
          reOp.firstMatch(monkeyRaw)?.group(1).toString() ?? '',
          reOp.firstMatch(monkeyRaw)?.group(2).toString() ?? ''
        ];
        int monkeyTest =
            int.tryParse(reTest.firstMatch(monkeyRaw)?.group(1) ?? '') ?? 0;
        int monkeyTrue =
            int.tryParse(reTrue.firstMatch(monkeyRaw)?.group(1) ?? '') ?? 0;
        int monkeyFalse =
            int.tryParse(reFalse.firstMatch(monkeyRaw)?.group(1) ?? '') ?? 0;
        Monkey newMonkey = Monkey(monkeyItems as List<int>, monkeyOp,
            monkeyTest, monkeyTrue, monkeyFalse);
        monkeys[monkeyCount] = (newMonkey);

        monkeyCount++;
      }

      for (int rounds = 1; rounds < 21; rounds++) {
        for (int monkeyNo in monkeys.keys) {
          Monkey currentMonkey = monkeys[monkeyNo];
          List currentItems = currentMonkey.items;
          for (int item in currentItems) {
            //inspection
            monkeys[monkeyNo].inspections++;
            item = (currentMonkey.operation[0] == '+'
                ? item + int.parse(currentMonkey.operation[1])
                : item *
                    (currentMonkey.operation[1] == 'old'
                        ? item
                        : int.parse(currentMonkey.operation[1])));
            //bored
            item = (item / 3).floor();

            //test
            if (item % currentMonkey.test == 0) {
              List<int> foo = monkeys[currentMonkey.trueMonkey].items.toList();
              foo.add(item);
              monkeys[currentMonkey.trueMonkey].items = foo;
            } else {
              List<int> foo = monkeys[currentMonkey.falseMonkey].items.toList();
              foo.add(item);
              monkeys[currentMonkey.falseMonkey].items = foo;
            }
          }
          monkeys[monkeyNo].items = List<int>.empty();
        }
      }
      printMonkeys();
      List<int> topMonkeys = [];

      for (int i in monkeys.keys) {
        topMonkeys.add(monkeys[i].inspections);
      }

      topMonkeys = topMonkeys..sort();
      print(topMonkeys);
      print(
          'Shenanegans - ${topMonkeys[topMonkeys.length - 1] * topMonkeys[topMonkeys.length - 2]}');
    });
  }

  void printMonkeys() {
    for (monkeyCount in monkeys.keys) {
      print('**** $monkeyCount\n${monkeys[monkeyCount]}');
    }
  }

  Future<String> readData() async {
    return (await File('data/11-monkeys-test.txt').readAsString());
  }
}

class Monkey {
  Monkey(List<int> items, List<String> operation, int test, int trueMonkey,
      int falseMonkey)
      : items = items,
        operation = operation,
        test = test,
        trueMonkey = trueMonkey,
        falseMonkey = falseMonkey,
        inspections = 0 {}
  List<int> items = [];
  List<String> operation;
  int test;
  int trueMonkey;
  int falseMonkey;
  int inspections;

  @override
  String toString() {
    return 'Items $items\nOperation $operation\nTest $test\nIf true: $trueMonkey\nIf false $falseMonkey\nInspections $inspections';
  }
}
