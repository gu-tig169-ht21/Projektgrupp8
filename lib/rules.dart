class RuleText {
  static String returnRules(String chosenRules) {
    if (chosenRules == 'how to play') {
      return 'Här skall vi skriva regler';
    } else if (chosenRules == 'card values') {
      return 'här skall vi skriva kort värdena';
    } else {
      return 'du gjorde fel';
    }
  }
}
