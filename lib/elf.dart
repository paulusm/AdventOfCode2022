class Elf {
  List<int> calories;

  Elf(List<int> cals) : calories = cals;

  int totalCals() {
    return calories.reduce((value, element) => value + element);
  }
}
