// klass med en IF sats som returnerar regler och kortvärden

class RuleText {
  static String returnRules(String chosenRules) {
    if (chosenRules == 'How to play') {
      return ' The goal of blackjack is for you to beat the dealer’s hand without going over 21 in value \n \n The face cards is worth 10 in value and the Aces is worth 1 or 11, depends on the situation \n \n Before the round starts you make your bet \n \n The round starts with the player (you) and the dealer gets two cards, one of the dealer’s cards is facing down, the other one is visible \n \n You have the choice to “hit” (asking for another card) or “stand” (you do not want to get any more cards) \n \n If the value of your cards are over 21, then you are bust and the dealer wins the round regardless of the dealer’s hand \n \n The dealer needs to draw until the value is 17 or higher \n \n Doubling means you double the bet and can only get one more card for this round \n \n Split is only possible if you have two of the same card. The pair is split into two hands and it also doubles the bet, both hands get the original bet \n \n If both the player (you) and the dealer gets the same value, then it’s a draw and you will get your bet back \n \n   ';
    } else if (chosenRules == 'Card values') {
      return 'Ace: 1 or 11 \n \n  2: 2 \n \n  3: 3 \n \n  4: 4 \n \n  5: 5 \n \n  6: 6 \n \n  7: 7 \n \n  8: 8 \n \n  9: 9 \n \n  10: 10 \n \n  Jack: 10 \n \n  Queen: 10 \n \n  King: 10';
    } else {
      return 'Du gjorde fel';
    }
  }
}
