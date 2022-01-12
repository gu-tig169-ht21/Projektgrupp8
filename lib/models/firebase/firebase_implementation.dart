import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/game_engine/deck_of_cards.dart';
import 'package:my_first_app/game_engine/error_handling.dart';
import 'package:playing_cards/playing_cards.dart';

class FirebaseAuthImplementation extends ChangeNotifier {
  FirebaseAuthImplementation() {
    init();
  }
  Future<void> init() async {
    _auth = FirebaseAuth.instance;
  }

  bool _usrLoggedIn = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  String? getUserEmail() {
    return _auth.currentUser?.email;
  }

  String? getUserId() {
    return _auth.currentUser?.uid;
  }

  bool isUserLoggedIn() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        _usrLoggedIn = false;
        notifyListeners();
      } else {
        _usrLoggedIn = true;
        notifyListeners();
      }
    });
    return _usrLoggedIn;
  }

  void createNewUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    //funktionen för att skapa en ny användare
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ErrorHandling().errorHandling(e, context);
        //throw FirebaseAuthException(code: 'weak-password');
      } else if (e.code == 'email-already-in-use') {
        ErrorHandling().errorHandling(e, context);
        // throw FirebaseAuthException(code: 'email-already-in-use');
      }
    } catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
  }

  void logIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    //funktion för att logga in en användare
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ErrorHandling().errorHandling(e, context);
      } else if (e.code == 'wrong-password') {
        ErrorHandling().errorHandling(e, context);
      }
    } catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
  }

  void signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
  }

  void deleteUser(String password, BuildContext context) async {
    //tar bort den nuvarande användaren
    String? email = _auth.currentUser?.email;

    try {
      await _auth.signInWithEmailAndPassword(email: email!, password: password);

      _auth.currentUser!.delete().then((_) {}).catchError((e) {
        ErrorHandling().errorHandling(e, context);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ErrorHandling().errorHandling(e, context);
      }
    }
  }

  void changeUserPassword(
      String password, String newPassword, BuildContext context) async {
    //byt den nuvarande användares lösenord
    String? email = _auth.currentUser?.email;

    try {
      await _auth.signInWithEmailAndPassword(email: email!, password: password);

      _auth.currentUser
          ?.updatePassword(newPassword)
          .then((_) {})
          .catchError((e) {
        ErrorHandling().errorHandling(e, context);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ErrorHandling().errorHandling(e, context);
      } else if (e.code == 'wrong-password') {
        ErrorHandling().errorHandling(e, context);
      }
    }
  }

  void reauthenticateUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      ErrorHandling().errorHandling(e, context);
    }
  }
}

class FirestoreImplementation extends ChangeNotifier {
  //klass för interaktion med firestoredatabas
  FirestoreImplementation() {
    init();
  }

  Future<void> init() async {
    _database = FirebaseFirestore.instance;
  }

  FirebaseFirestore _database = FirebaseFirestore.instance;

  void createNewUsrStat(
      {required String userId, required BuildContext context}) async {
    //skapar ett nytt dokument i databasen(används när en ny användare registreras)
    CollectionReference statistics = _database.collection('Statistics');

    final snapShot = await statistics.doc(userId).get();

    if (snapShot.exists) {
    } else {
      await statistics.doc(userId).set({
        'wins': 0,
        'losses': 0,
        'gamesPlayed': 0,
        'splits': {
          'splitRounds': 0,
          'splitWins': 0,
          'splitLosses': 0,
        },
        'balance': 0,
        'starWarsDeckUnlocked': false,
        'goldenDeckUnlocked': false,
        'chosenDeck': 'Standard',
        'drawnCards': {
          'spades': {
            'aceSpades': 0,
            'kingSpades': 0,
            'queenSpades': 0,
            'jackSpades': 0,
            'tenSpades': 0,
            'nineSpades': 0,
            'eightSpades': 0,
            'sevenSpades': 0,
            'sixSpades': 0,
            'fiveSpades': 0,
            'fourSpades': 0,
            'threeSpades': 0,
            'twoSpades': 0,
          },
          'clubs': {
            'aceClubs': 0,
            'kingClubs': 0,
            'queenClubs': 0,
            'jackClubs': 0,
            'tenClubs': 0,
            'nineClubs': 0,
            'eightClubs': 0,
            'sevenClubs': 0,
            'sixClubs': 0,
            'fiveClubs': 0,
            'fourClubs': 0,
            'threeClubs': 0,
            'twoClubs': 0,
          },
          'hearts': {
            'aceHearts': 0,
            'kingHearts': 0,
            'queenHearts': 0,
            'jackHearts': 0,
            'tenHearts': 0,
            'nineHearts': 0,
            'eightHearts': 0,
            'sevenHearts': 0,
            'sixHearts': 0,
            'fiveHearts': 0,
            'fourHearts': 0,
            'threeHearts': 0,
            'twoHearts': 0,
          },
          'diamonds': {
            'aceDiamonds': 0,
            'kingDiamonds': 0,
            'queenDiamonds': 0,
            'jackDiamonds': 0,
            'tenDiamonds': 0,
            'nineDiamonds': 0,
            'eightDiamonds': 0,
            'sevenDiamonds': 0,
            'sixDiamonds': 0,
            'fiveDiamonds': 0,
            'fourDiamonds': 0,
            'threeDiamonds': 0,
            'twoDiamonds': 0,
          },
        },
      }).catchError((e) => ErrorHandling().errorHandling(e, context));
    }
  }

  void incrementCardInDB(
      {required PlayingCard card,
      required String userId,
      required BuildContext context}) {
    CollectionReference statistics = _database.collection('Statistics');

    statistics.doc(userId).update({
      'drawnCards.${DeckOfCards().suitToString(card)}.${DeckOfCards().cardToString(card)}':
          FieldValue.increment(1)
    }).catchError((e) => ErrorHandling().errorHandling(e, context));
  }

  void incrementGameCountAndWinOrLose(
      {required bool split,
      required String splitWinOrLose,
      required String winOrLose,
      required String userId,
      required BuildContext context}) {
    CollectionReference statistics = _database.collection('Statistics');
    if (!split) {
      if (winOrLose == 'Win') {
        statistics.doc(userId).update({
          'gamesPlayed': FieldValue.increment(1),
          'wins': FieldValue.increment(1)
        }).catchError((e) => ErrorHandling().errorHandling(e, context));
      } else if (winOrLose == 'Lose') {
        statistics.doc(userId).update({
          'gamesPlayed': FieldValue.increment(1),
          'losses': FieldValue.increment(1)
        }).catchError((e) => ErrorHandling().errorHandling(e, context));
      } else {
        statistics.doc(userId).update({
          'gamesPlayed': FieldValue.increment(1),
        }).catchError((e) => ErrorHandling().errorHandling(e, context));
      }
    } else {
      if (winOrLose == 'Win' && splitWinOrLose == 'Win') {
        statistics.doc(userId).update({
          'gamesPlayed': FieldValue.increment(1),
          'wins': FieldValue.increment(1),
          'splits.splitRounds': FieldValue.increment(1),
          'splits.splitWins': FieldValue.increment(1)
        }).catchError((e) => ErrorHandling().errorHandling(e, context));
      } else if (winOrLose == 'Win' && splitWinOrLose == 'Lose') {
        statistics.doc(userId).update({
          'gamesPlayed': FieldValue.increment(1),
          'wins': FieldValue.increment(1),
          'splits.splitRounds': FieldValue.increment(1),
          'splits.splitLosses': FieldValue.increment(1)
        }).catchError((e) => ErrorHandling().errorHandling(e, context));
      } else if (winOrLose == 'Lose' && splitWinOrLose == 'Win') {
        statistics.doc(userId).update({
          'gamesPlayed': FieldValue.increment(1),
          'losses': FieldValue.increment(1),
          'splits.splitRounds': FieldValue.increment(1),
          'splits.splitWins': FieldValue.increment(1)
        }).catchError((e) => ErrorHandling().errorHandling(e, context));
      } else if (winOrLose == 'Lose' && splitWinOrLose == 'Lose') {
        statistics.doc(userId).update({
          'gamesPlayed': FieldValue.increment(1),
          'losses': FieldValue.increment(1),
          'splits.splitRounds': FieldValue.increment(1),
          'splits.splitLosses': FieldValue.increment(1)
        }).catchError((e) => ErrorHandling().errorHandling(e, context));
      } else if (winOrLose == 'Draw' && splitWinOrLose == 'Win') {
        statistics.doc(userId).update({
          'gamesPlayed': FieldValue.increment(1),
          'splits.splitRounds': FieldValue.increment(1),
          'splits.splitWins': FieldValue.increment(1)
        }).catchError((e) => ErrorHandling().errorHandling(e, context));
      } else if (winOrLose == 'Draw' && splitWinOrLose == 'Lose') {
        statistics.doc(userId).update({
          'gamesPlayed': FieldValue.increment(1),
          'splits.splitRounds': FieldValue.increment(1),
          'splits.splitLosses': FieldValue.increment(1)
        }).catchError((e) => ErrorHandling().errorHandling(e, context));
      } else if (winOrLose == 'Win' && splitWinOrLose == 'Draw') {
        statistics.doc(userId).update({
          'gamesPlayed': FieldValue.increment(1),
          'wins': FieldValue.increment(1),
          'splits.splitRounds': FieldValue.increment(1),
        }).catchError((e) => ErrorHandling().errorHandling(e, context));
      } else if (winOrLose == 'Lose' && splitWinOrLose == 'Draw') {
        statistics.doc(userId).update({
          'gamesPlayed': FieldValue.increment(1),
          'losses': FieldValue.increment(1),
          'splits.splitRounds': FieldValue.increment(1),
        }).catchError((e) => ErrorHandling().errorHandling(e, context));
      } else {
        statistics.doc(userId).update({
          'gamesPlayed': FieldValue.increment(1),
          'splits.splitRounds': FieldValue.increment(1),
        }).catchError((e) => ErrorHandling().errorHandling(e, context));
      }
    }
  }

  Future<String> getChosenDeckTheme(
      {required String userId, required BuildContext context}) async {
    CollectionReference statistics = _database.collection('Statistics');
    String returnString = 'Something went wrong';

    await statistics
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          returnString = documentSnapshot['chosenDeck'];
        } on StateError catch (e) {
          ErrorHandling().errorHandling(e, context);
        }
      }
    });

    return returnString;
  }

  void changeDeckTheme(
      {required String deck,
      required String userId,
      required BuildContext context}) {
    //ändrar standardval på kortlekstema
    CollectionReference statistics = _database.collection('Statistics');

    statistics.doc(userId).update({'chosenDeck': deck}).catchError(
        (e) => ErrorHandling().errorHandling(e, context));
  }

  Future<bool> getUnlockedDeck(
      {required String deck,
      required String userId,
      required BuildContext context}) async {
    CollectionReference statistics = _database.collection('Statistics');
    bool returnBool = false;
    String deckFieldValue = 'starWarsDeckUnlocked';
    if (deck == 'StarWars') {
      deckFieldValue = 'starWarsDeckUnlocked';
    } else if (deck == 'Golden') {
      deckFieldValue = 'goldenDeckUnlocked';
    }

    await statistics
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          returnBool = documentSnapshot[deckFieldValue];
        } on StateError catch (e) {
          ErrorHandling().errorHandling(e, context);
        }
      }
    });

    return returnBool;
  }

  void unlockDeck(
      {required String deck,
      required String userId,
      required BuildContext context}) {
    CollectionReference statistics = _database.collection('Statistics');

    if (deck == 'StarWars') {
      statistics.doc(userId).update({'starWarsDeckUnlocked': true}).catchError(
          (e) => ErrorHandling().errorHandling(e, context));
    } else if (deck == 'Golden') {
      statistics.doc(userId).update({'goldenDeckUnlocked': true}).catchError(
          (e) => ErrorHandling().errorHandling(e, context));
    }
  }

  Future<int> getGamesPlayed(
      {required String userId, required BuildContext context}) async {
    CollectionReference statistics = _database.collection('Statistics');
    int returnInt = 0;

    await statistics
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          returnInt = documentSnapshot['gamesPlayed'];
        } on StateError catch (e) {
          ErrorHandling().errorHandling(e, context);
        }
      }
    });

    return returnInt;
  }

  Future<int> getGamesWon(
      {required String userId, required BuildContext context}) async {
    CollectionReference statistics = _database.collection('Statistics');
    int returnInt = 0;

    await statistics
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          returnInt = documentSnapshot['wins'];
        } on StateError catch (e) {
          ErrorHandling().errorHandling(e, context);
        }
      }
    });

    return returnInt;
  }

  Future<int> getGamesLost(
      {required String userId, required BuildContext context}) async {
    CollectionReference statistics = _database.collection('Statistics');
    int returnInt = 0;

    await statistics
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          returnInt = documentSnapshot['losses'];
        } on StateError catch (e) {
          ErrorHandling().errorHandling(e, context);
        }
      }
    });

    return returnInt;
  }

  Future<dynamic> getDrawnCards(
      {required String userId, required BuildContext context}) async {
    CollectionReference statistics = _database.collection('Statistics');
    Map<String, dynamic> returnMap = <String, dynamic>{};

    await statistics
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          returnMap =
              documentSnapshot['drawnCards.spades'] as Map<String, dynamic>;
          returnMap.addAll(
              documentSnapshot['drawnCards.clubs'] as Map<String, dynamic>);
          returnMap.addAll(
              documentSnapshot['drawnCards.diamonds'] as Map<String, dynamic>);
          returnMap.addAll(
              documentSnapshot['drawnCards.hearts'] as Map<String, dynamic>);
        } on StateError catch (e) {
          ErrorHandling().errorHandling(e, context);
        }
      }
    });

    return returnMap;
  }

  Future<int> getBalance(
      {required String userId, required BuildContext context}) async {
    CollectionReference statistics = _database.collection('Statistics');
    int returnInt = 0;

    await statistics
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          returnInt = documentSnapshot['balance'];
        } on StateError catch (e) {
          ErrorHandling().errorHandling(e, context);
        }
      }
    });

    return returnInt;
  }

  Future<void> changeBalance(
      {required String userId,
      required int change,
      required add,
      required BuildContext context}) async {
    CollectionReference statistics = _database.collection('Statistics');

    if (add) {
      await statistics
          .doc(userId)
          .update({'balance': FieldValue.increment(change)}).catchError(
              (e) => ErrorHandling().errorHandling(e, context));
    } else {
      await statistics
          .doc(userId)
          .update({'balance': FieldValue.increment(-change)}).catchError(
              (e) => ErrorHandling().errorHandling(e, context));
    }
  }
}
