import 'package:playing_cards/playing_cards.dart';
import 'dart:math';

class DeckOfCards {
  //List<PlayingCard> deck = standardFiftyTwoCardDeck(); //ska den ligga här?
  final _random = Random();

  PlayingCard pickACard(List<PlayingCard> deck) {
    //returnerar ett kort och tar bort det ur leken
    int i = _random.nextInt(deck.length);
    PlayingCard card = deck[i];
    //deck.removeAt(i);
    return card;
  }

  // List<PlayingCard> resetDeck() {
  //   //resettar kortleken
  //   return standardFiftyTwoCardDeck();
  // }
  String cardToString(PlayingCard card) {
    switch (card.suit) {
      case Suit.spades:
        {
          switch (card.value) {
            case CardValue.ace:
              {
                return 'aceSpades';
              }
            case CardValue.two:
              {
                return 'twoSpades';
              }
            case CardValue.three:
              {
                return 'threeSpades';
              }
            case CardValue.four:
              {
                return 'fourSpades';
              }
            case CardValue.five:
              {
                return 'fiveSpades';
              }
            case CardValue.six:
              {
                return 'sixSpades';
              }
            case CardValue.seven:
              {
                return 'sevenSpades';
              }
            case CardValue.eight:
              {
                return 'eightSpades';
              }
            case CardValue.nine:
              {
                return 'nineSpades';
              }
            case CardValue.ten:
              {
                return 'tenSpades';
              }
            case CardValue.jack:
              {
                return 'jackSpades';
              }
            case CardValue.queen:
              {
                return 'queenSpades';
              }
            case CardValue.king:
              {
                return 'kingSpades';
              }
          }
        }
      case Suit.clubs:
        {
          switch (card.value) {
            case CardValue.ace:
              {
                return 'aceClubs';
              }
            case CardValue.two:
              {
                return 'twoClubs';
              }
            case CardValue.three:
              {
                return 'threeClubs';
              }
            case CardValue.four:
              {
                return 'fourClubs';
              }
            case CardValue.five:
              {
                return 'fiveClubs';
              }
            case CardValue.six:
              {
                return 'sixClubs';
              }
            case CardValue.seven:
              {
                return 'sevenClubs';
              }
            case CardValue.eight:
              {
                return 'eightClubs';
              }
            case CardValue.nine:
              {
                return 'nineClubs';
              }
            case CardValue.ten:
              {
                return 'tenClubs';
              }
            case CardValue.jack:
              {
                return 'jackClubs';
              }
            case CardValue.queen:
              {
                return 'queenClubs';
              }
            case CardValue.king:
              {
                return 'kingClubs';
              }
          }
        }
      case Suit.hearts:
        {
          switch (card.value) {
            case CardValue.ace:
              {
                return 'aceHearts';
              }
            case CardValue.two:
              {
                return 'twoHearts';
              }
            case CardValue.three:
              {
                return 'threeHearts';
              }
            case CardValue.four:
              {
                return 'fourHearts';
              }
            case CardValue.five:
              {
                return 'fiveHearts';
              }
            case CardValue.six:
              {
                return 'sixHearts';
              }
            case CardValue.seven:
              {
                return 'sevenHearts';
              }
            case CardValue.eight:
              {
                return 'eightHearts';
              }
            case CardValue.nine:
              {
                return 'nineHearts';
              }
            case CardValue.ten:
              {
                return 'tenHearts';
              }
            case CardValue.jack:
              {
                return 'jackHearts';
              }
            case CardValue.queen:
              {
                return 'queenHearts';
              }
            case CardValue.king:
              {
                return 'kingHearts';
              }
          }
        }
      case Suit.diamonds:
        {
          switch (card.value) {
            case CardValue.ace:
              {
                return 'aceDiamonds';
              }
            case CardValue.two:
              {
                return 'twoDiamonds';
              }
            case CardValue.three:
              {
                return 'threeDiamonds';
              }
            case CardValue.four:
              {
                return 'fourDiamonds';
              }
            case CardValue.five:
              {
                return 'fiveDiamonds';
              }
            case CardValue.six:
              {
                return 'sixDiamonds';
              }
            case CardValue.seven:
              {
                return 'sevenDiamonds';
              }
            case CardValue.eight:
              {
                return 'eightDiamonds';
              }
            case CardValue.nine:
              {
                return 'nineDiamonds';
              }
            case CardValue.ten:
              {
                return 'tenDiamonds';
              }
            case CardValue.jack:
              {
                return 'jackDiamonds';
              }
            case CardValue.queen:
              {
                return 'queenDiamonds';
              }
            case CardValue.king:
              {
                return 'kingDiamonds';
              }
          }
        }
    }
  }

  String suitToString(PlayingCard card) {
    switch (card.suit) {
      case Suit.spades:
        {
          return 'spades';
        }
      case Suit.clubs:
        {
          return 'clubs';
        }
      case Suit.hearts:
        {
          return 'hearts';
        }
      case Suit.diamonds:
        {
          return 'diamonds';
        }
    }
  }

  int valueOfCard(PlayingCard card) {
    //returnerar värdet av ett specifikt kort
    switch (card.value) {
      case CardValue.ace:
        {
          return 11;
        }
      case CardValue.two:
        {
          return 2;
        }
      case CardValue.three:
        {
          return 3;
        }
      case CardValue.four:
        {
          return 4;
        }
      case CardValue.five:
        {
          return 5;
        }
      case CardValue.six:
        {
          return 6;
        }
      case CardValue.seven:
        {
          return 7;
        }
      case CardValue.eight:
        {
          return 8;
        }
      case CardValue.nine:
        {
          return 9;
        }
      case CardValue.ten:
        {
          return 10;
        }
      case CardValue.jack:
        {
          return 10;
        }
      case CardValue.queen:
        {
          return 10;
        }
      case CardValue.king:
        {
          return 10;
        }
    }
  }

  int handValue(List<PlayingCard> hand) {
    //returnerar värdet av en "hand" (lista av kort)
    int value = 0;
    var test = hand.where((element) => element.value == CardValue.ace);

    for (PlayingCard card in hand) {
      value += valueOfCard(card);
    }
    if (value > 21 && test.isNotEmpty && test.length == 1) {
      value -= 10;
    } else if (value > 21 && test.isNotEmpty && test.length == 2) {
      if (value - 10 <= 21) {
        value -= 10;
      } else {
        value -= 20;
      }
    } else if (value > 21 && test.isNotEmpty && test.length == 3) {
      if (value - 10 <= 21) {
        value -= 10;
      } else if (value - 20 <= 21) {
        value -= 20;
      } else {
        value -= 30;
      }
    } else if (value > 21 && test.isNotEmpty && test.length == 4) {
      if (value - 10 <= 21) {
        value -= 10;
      } else if (value - 20 <= 21) {
        value -= 20;
      } else if (value - 30 <= 21) {
        value -= 30;
      } else {
        value -= 40;
      }
    }

    return value;
  }
}
