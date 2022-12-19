import 'dart:io';

class Day19 {
  Day19() {
    RegExp robotParser = RegExp(
        r'(Blueprint (\d+): )?Each (.*) robot costs (\d+) ore( and (\d+) (.*))?');
    readData().then((data) {
      for (String line in data) {
        List<String> dataSegments = line.split('.');
        for (String segment in dataSegments) {
          print('Parsing $segment');
          RegExpMatch? robotMatches = robotParser.firstMatch(segment);
          if (robotMatches != null) {
            print('Blueprint no ${robotMatches[2]}');
            print('Robot type ${robotMatches[3]}');
            print('Ore cost ${robotMatches[4]}');
            print((robotMatches[7] == 'clay'
                ? 'Clay Cost ${robotMatches[6]}'
                : 'Obsidian Cost ${robotMatches[6]}'));
          }
        }
      }
    });
  }

  Future<List<String>> readData() async {
    return File('data/19-robots-test.txt').readAsLines();
  }
}
