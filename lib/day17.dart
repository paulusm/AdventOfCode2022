import 'dart:io';

class Day17 {
  Day17() {}

  Future<List<String>> readData() async {
    return File('data/17.txt').readAsLines();
  }
}
