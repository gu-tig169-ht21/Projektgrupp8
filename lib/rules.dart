// klass med en IF sats som returnerar regler och kortvärden

class RuleText {
  static String returnRules(String chosenRules) {
    if (chosenRules == 'How to play') {
      return 'Här skall vi skriva regler';
    } else if (chosenRules == 'Card values') {
      return 'Här skall vi skriva kort värdena';
    } else {
      return 'Du gjorde fel';
    }
  }
}
