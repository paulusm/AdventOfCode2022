import 'package:dart_advent/dart_advent.dart' as dart_advent;

void main(List<String> arguments) {
  dart_advent.Advent advent = dart_advent.Advent();
  advent.loadCals().then((numLoaded) {
    print(' ${numLoaded} elves loaded!');
    print('most cals for one elf ${advent.maxCals()}!');
  });
}
