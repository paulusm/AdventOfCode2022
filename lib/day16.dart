import 'dart:collection';
import 'dart:io';

class Day16 {
  List<Valve> valveList = [];
  int time = 30;
  int maxFlow = 0;

  Day16() {
    readData().then((data) {
      RegExp dataMatch = RegExp(
          r'Valve (\S\S) has flow rate=(\d+); tunnels lead to valves (.*)');
      for (String line in data) {
        RegExpMatch? matchResults = dataMatch.firstMatch(line);
        if (matchResults != null) {
          Valve newValve = Valve(
              matchResults[1] ?? '',
              int.parse(matchResults[2] ?? ''),
              (matchResults[3] ?? '').split(',').map((e) => e.trim()).toList());
          valveList.add(newValve);
        }
      }
      optimiseFlow(getValve('AA'));
      print(maxFlow);
    });
  }

  optimiseFlow(Valve currentValve) {
    // while (time > 0) {
    //   if (!currentValve.isOpen && currentValve.flowRate > 0) {
    //     print('Opening ${currentValve.id}');
    //     //open valve
    //     currentValve.open();
    //     time--;
    //     maxFlow += currentValve.flowRate * time;
    //   }

    HashMap pathScore =
        evaluatePath(currentValve.linkedValves[0].Id, HashMap());

    print(pathScore);

    // }
    // print('At - ${currentValve.id} - mins $time, flow score - $maxFlow');
    // print('Moving to ${bestValve.id}');
    // time--;
    // //optimiseFlow(bestValve);
    //}
  }

  HashMap evaluatePath(String valveId, HashMap soFar) {
    int steps = 1;
    Valve currentValve = getValve(valveId);
    if (!currentValve.isOpen) {
      soFar[valveId] = currentValve.flowRate;
    }
    for (String valveId in currentValve.linkedValves) {
      steps++;
      if (steps < 3) {
        soFar = evaluatePath(valveId, soFar);
      }
    }
    return soFar;
  }

  Valve getValve(String valveID) {
    return valveList.where((element) => element.id == valveID).single;
  }

  Future<List<String>> readData() async {
    return File('data/16-valves-test.txt').readAsLines();
  }
}

class Valve {
  String id;
  int flowRate;
  bool isOpen = false;
  List linkedValves;
  Valve(String id, int flow, List linked)
      : id = id,
        flowRate = flow,
        linkedValves = linked {}
  void open() {
    isOpen = true;
  }
}
