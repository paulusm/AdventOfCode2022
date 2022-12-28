import 'dart:collection';
import 'dart:io';

class Day19 {
  HashMap factory = HashMap();
  HashMap productionRatios = HashMap();

  Day19() {
    RegExp robotParser = RegExp(
        r'(Blueprint (\d+): )?Each (.*) robot costs (\d+) ore( and (\d+) (.*))?');
    readData().then((data) {
      for (String line in data) {
        int currentBPNo = 1;
        LinkedHashMap currentBluePrint = LinkedHashMap();
        List<String> dataSegments = line.split('.');
        for (String segment in dataSegments) {
          //print('Parsing $segment');
          String currentType = '';
          int oreCost = 0;
          int otherCost = 0;

          RegExpMatch? robotMatches = robotParser.firstMatch(segment);
          if (robotMatches != null) {
            if (robotMatches[2] != null) {
              currentBPNo = int.parse(robotMatches[2] ?? '');
            }

            //print('Blueprint no $currentBPNo');
            currentType = robotMatches[3] ?? '';
            //print('Robot type $currentType');
            oreCost = int.parse(robotMatches[4] ?? '');
            //print('Ore cost $oreCost');
            if (robotMatches[6] != null) {
              otherCost = int.parse(robotMatches[6] ?? '');
              //print('Other cost $otherCost');
            }
          }
          Robot newBot = OreBot(0);

          switch (currentType) {
            case 'ore':
              newBot = OreBot(oreCost);
              break;
            case 'clay':
              newBot = ClayBot(oreCost);
              break;
            case 'obsidian':
              newBot = ObsidianBot(oreCost, otherCost);
              productionRatios['$currentBPNo-obsidian'] = otherCost / oreCost;
              break;
            case 'geode':
              newBot = GeodeBot(oreCost, otherCost);
              productionRatios['$currentBPNo-geode'] = otherCost / oreCost;
              break;
          }
          if (currentType != '') currentBluePrint[currentType] = newBot;
        }
        factory[currentBPNo] = currentBluePrint;
      }
      //print(factory);
      print(runTheNumbers());
    });
  }

  int runTheNumbers() {
    for (int bpNo in factory.keys) {
      List<Robot> inventory = [];

      int oreStock = 0;
      int clayStock = 0;
      int obsidianStock = 0;
      int geodesCracked = 0;
      int orePotential = 0;
      int clayPotential = 0;
      int obsidianPotential = 0;
      int geodePotential = 0;
      print("\nBlueprint $bpNo\n");
      bool slotAvailable = true;
      Robot? botManufactured;

      //starter bot
      inventory.add(OreBot(0));
      orePotential += 24;

      for (int min = 23; min >= 0; min--) {
        slotAvailable = true;
        botManufactured = null;

        print("Minutes ${24 - min}");
        //print("Bots in inventory ${inventory.length}");

        //See what we can add to inventory

        //print(factory[bpNo].keys.toList().reversed);
        for (String botType in factory[bpNo].keys.toList().reversed) {
          int cbOreCost = factory[bpNo][botType].costOre;

          switch (botType) {
            case 'geode':
              int cbObsidianCost = factory[bpNo][botType].costObsidian;

              if (obsidianStock >= cbObsidianCost &&
                  oreStock >= cbOreCost &&
                  slotAvailable) {
                botManufactured = factory[bpNo][botType];
                slotAvailable = false;
                print('Build $botType bot');
                obsidianStock -= cbObsidianCost;
                oreStock -= cbOreCost;
                geodePotential += min;
              }
              break;
            case 'obsidian':
              int cbClayCost = factory[bpNo][botType].costClay;
              //print('ratio - ${productionRatios['$bpNo-geode']}');
              if (clayStock >= cbClayCost &&
                  oreStock >= cbOreCost &&
                  slotAvailable) {
                botManufactured = factory[bpNo][botType];
                slotAvailable = false;
                print('Build $botType bot');
                clayStock -= cbClayCost;
                oreStock -= cbOreCost;
                obsidianPotential += min;
              }
              break;
            case 'clay':
              //()
              if (oreStock >= cbOreCost &&
                  slotAvailable &&
                  clayStock / oreStock <= 3) {
                //productionRatios['$bpNo-obsidian']) {
                botManufactured = factory[bpNo][botType];
                slotAvailable = false;
                print('Build $botType bot');
                oreStock -= cbOreCost;
                clayPotential += min;
              }
              break;
            case 'ore':
              if (oreStock >= cbOreCost && slotAvailable) {
                botManufactured = factory[bpNo][botType];
                slotAvailable = false;
                print('Build $botType bot');
                oreStock -= cbOreCost;
                orePotential += min;
              }
              break;
          }
        }
        for (Robot bot in inventory) {
          //print('inventory - ${bot.runtimeType.toString()}');
          switch (bot.runtimeType.toString()) {
            case 'OreBot':
              oreStock++;
              break;
            case 'ClayBot':
              clayStock++;
              break;
            case 'ObsidianBot':
              obsidianStock++;
              break;
            case 'GeodeBot':
              geodesCracked++;
              break;
          }
        }
        // print(factory[bpNo]['geode'].costObsidian);
        print(
            'STOCK obsid - $obsidianStock, clay- $clayStock, ore - $oreStock');
        print(
            'POTENTIAL obsid - $obsidianPotential, clay- $clayPotential, ore - $orePotential');
        if (botManufactured != null) inventory.add(botManufactured);
      }
      print('\n End of $bpNo');
      print('Ore - $oreStock');
      print('Clay - $clayStock');
      print('Obsidian - $obsidianStock');
      print('Geode - $geodesCracked');
      print('Bots in inventory - ${inventory.length}');
    }
    return 1;
  }

  Future<List<String>> readData() async {
    return File('data/19-robots-test.txt').readAsLines();
  }
}

class Robot {
  Robot(int oreCost) : costOre = oreCost;
  int costOre;

  String toString() {
    return '\nType:${this.runtimeType.toString()}\nOre Cost $costOre\n';
  }
}

class OreBot extends Robot {
  OreBot(int oreCost) : super(oreCost) {}
}

class ClayBot extends Robot {
  ClayBot(int oreCost) : super(oreCost) {}
}

class ObsidianBot extends Robot {
  ObsidianBot(int oreCost, int clayCost)
      : costClay = clayCost,
        super(oreCost) {}
  int costClay;

  String toString() {
    return '\nType:${this.runtimeType.toString()}\nOre Cost $costOre\nClay Cost $costClay\n';
  }
}

class GeodeBot extends Robot {
  GeodeBot(int oreCost, int obsidianCost)
      : costObsidian = obsidianCost,
        super(oreCost) {}
  int costObsidian;
}
