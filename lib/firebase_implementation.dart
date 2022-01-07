import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_first_app/card_themes.dart';
import 'package:my_first_app/deck_of_cards.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

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

  void createNewUser({required String email, required String password}) async {
    //funktionen för att skapa en ny användare
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw FirebaseAuthException(code: 'weak-password');
      } else if (e.code == 'email-already-in-use') {
        throw FirebaseAuthException(code: 'email-already-in-use');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
//TODO: skicka verifikationsmejl till nya användare

  void logIn({required String email, required String password}) async {
    //funktion för att logga in en användare
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(code: e.code);
      } else if (e.code == 'wrong-password') {
        throw FirebaseAuthException(code: e.code);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void signOut() async {
    await _auth.signOut();
  }

  void deleteUser(String password) async {
    //tar bort den nuvarande användaren
    String? email = _auth.currentUser?.email;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email!, password: password);

      _auth.currentUser!.delete().then((_) {
        print('user deleted'); //TODO: felutskrift
      }).catchError((error) {
        print('Deletion not completed: ' + error.toString());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception(
            'The user must authenticate to be able to delete account');
      }
    }
  }

  void changeUserPassword(String password, String newPassword) async {
    //byt den nuvarande användares lösenord
    String? email = _auth.currentUser?.email;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email!, password: password);

      _auth.currentUser?.updatePassword(newPassword).then((_) {
        print('succesully changes password');
      }).catchError((error) {
        print('password cant be changed: ' + error.toString());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(code: 'user-not-found');
      } else if (e.code == 'wrong-password') {
        throw FirebaseAuthException(code: 'wrong-password');
      }
    }
  }

  void reauthenticateUser(
      {required String email, required String password}) async {
    //TODO: lägg till try här med
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    await _auth.currentUser!.reauthenticateWithCredential(credential);
  }
}

class FirestoreImplementation extends ChangeNotifier {
  //klass för interaktion med firestoredatabas
  FirestoreImplementation() {
    init();
  }

  Future<void> init() async {
    database = FirebaseFirestore.instance;
    //TODO: implementation av firestore
  }

  FirebaseFirestore database = FirebaseFirestore.instance;

  void createNewUsrStat({required String userId}) async {
    //skapar ett nytt dokument i databasen(används när en ny användare registreras)
    CollectionReference statistics = database.collection('Statistics');

    final snapShot = await statistics.doc(userId).get();

    if (snapShot.exists) {
      print('document already exists');
    } else {
      await statistics
          .doc(userId)
          .set({
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
          })
          .then((value) => print('user stats generated'))
          .catchError((error) =>
              print(error.toString())); //TODO: fixa riktig felhantering
    }
  }

  void incrementCardInDB({required PlayingCard card, required String userId}) {
    CollectionReference statistics = database.collection('Statistics');

    statistics
        .doc(userId)
        .update({
          'drawnCards.${DeckOfCards().suitToString(card)}.${DeckOfCards().cardToString(card)}':
              FieldValue.increment(1)
        })
        .then((value) => print('card updated'))
        .catchError(
            (error) => print(error.toString())); //TODO:riktig felhantering
  }

  void incrementGameCountAndWinOrLose(
      {required bool split,
      required String splitWinOrLose,
      required String winOrLose,
      required String userId}) {
    CollectionReference statistics = database.collection('Statistics');
    if (!split) {
      if (winOrLose == 'Win') {
        statistics
            .doc(userId)
            .update({
              'gamesPlayed': FieldValue.increment(1),
              'wins': FieldValue.increment(1)
            })
            .then((value) => print('games played & wins updated'))
            .catchError(
                (error) => print(error.toString())); //TODO:riktig felhantering
      } else if (winOrLose == 'Lose') {
        statistics
            .doc(userId)
            .update({
              'gamesPlayed': FieldValue.increment(1),
              'losses': FieldValue.increment(1)
            })
            .then((value) => print('games played & wins updated'))
            .catchError(
                (error) => print(error.toString())); //TODO:riktig felhantering
      } else {
        statistics
            .doc(userId)
            .update({
              'gamesPlayed': FieldValue.increment(1),
            })
            .then((value) => print('games played & wins updated'))
            .catchError(
                (error) => print(error.toString())); //TODO:riktig felhantering
      }
    } else {
      if (winOrLose == 'Win' && splitWinOrLose == 'Win') {
        statistics
            .doc(userId)
            .update({
              'gamesPlayed': FieldValue.increment(1),
              'wins': FieldValue.increment(1),
              'splits.splitRounds': FieldValue.increment(1),
              'splits.splitWins': FieldValue.increment(1)
            })
            .then((value) => print('games played & wins updated'))
            .catchError(
                (error) => print(error.toString())); //TODO:riktig felhantering
      } else if (winOrLose == 'Win' && splitWinOrLose == 'Lose') {
        statistics
            .doc(userId)
            .update({
              'gamesPlayed': FieldValue.increment(1),
              'wins': FieldValue.increment(1),
              'splits.splitRounds': FieldValue.increment(1),
              'splits.splitLosses': FieldValue.increment(1)
            })
            .then((value) => print('games played & wins updated'))
            .catchError(
                (error) => print(error.toString())); //TODO:riktig felhantering
      } else if (winOrLose == 'Lose' && splitWinOrLose == 'Win') {
        statistics
            .doc(userId)
            .update({
              'gamesPlayed': FieldValue.increment(1),
              'losses': FieldValue.increment(1),
              'splits.splitRounds': FieldValue.increment(1),
              'splits.splitWins': FieldValue.increment(1)
            })
            .then((value) => print('games played & wins updated'))
            .catchError(
                (error) => print(error.toString())); //TODO:riktig felhantering
      } else if (winOrLose == 'Lose' && splitWinOrLose == 'Lose') {
        statistics
            .doc(userId)
            .update({
              'gamesPlayed': FieldValue.increment(1),
              'losses': FieldValue.increment(1),
              'splits.splitRounds': FieldValue.increment(1),
              'splits.splitLosses': FieldValue.increment(1)
            })
            .then((value) => print('games played & wins updated'))
            .catchError(
                (error) => print(error.toString())); //TODO:riktig felhantering
      } else if (winOrLose == 'Draw' && splitWinOrLose == 'Win') {
        statistics
            .doc(userId)
            .update({
              'gamesPlayed': FieldValue.increment(1),
              'splits.splitRounds': FieldValue.increment(1),
              'splits.splitWins': FieldValue.increment(1)
            })
            .then((value) => print('games played & wins updated'))
            .catchError(
                (error) => print(error.toString())); //TODO:riktig felhantering
      } else if (winOrLose == 'Draw' && splitWinOrLose == 'Lose') {
        statistics
            .doc(userId)
            .update({
              'gamesPlayed': FieldValue.increment(1),
              'splits.splitRounds': FieldValue.increment(1),
              'splits.splitLosses': FieldValue.increment(1)
            })
            .then((value) => print('games played & wins updated'))
            .catchError(
                (error) => print(error.toString())); //TODO:riktig felhantering
      } else if (winOrLose == 'Win' && splitWinOrLose == 'Draw') {
        statistics
            .doc(userId)
            .update({
              'gamesPlayed': FieldValue.increment(1),
              'wins': FieldValue.increment(1),
              'splits.splitRounds': FieldValue.increment(1),
            })
            .then((value) => print('games played & wins updated'))
            .catchError(
                (error) => print(error.toString())); //TODO:riktig felhantering
      } else if (winOrLose == 'Lose' && splitWinOrLose == 'Draw') {
        statistics
            .doc(userId)
            .update({
              'gamesPlayed': FieldValue.increment(1),
              'losses': FieldValue.increment(1),
              'splits.splitRounds': FieldValue.increment(1),
            })
            .then((value) => print('games played & wins updated'))
            .catchError(
                (error) => print(error.toString())); //TODO:riktig felhantering
      } else {
        statistics
            .doc(userId)
            .update({
              'gamesPlayed': FieldValue.increment(1),
              'splits.splitRounds': FieldValue.increment(1),
            })
            .then((value) => print('games played & wins updated'))
            .catchError(
                (error) => print(error.toString())); //TODO:riktig felhantering
      }
    }
  }

  void changeBalance(
      {required int change, required bool add, required String userId}) {
    CollectionReference statistics = database.collection('Statistics');

    if (add) {
      statistics
          .doc(userId)
          .update({'balance': FieldValue.increment(change)})
          .then((value) => print('Balance updated'))
          .catchError(
              (error) => print(error.toString())); //TODO:riktig felhantering
    } else {
      statistics
          .doc(userId)
          .update({'balance': FieldValue.increment(-change)})
          .then((value) => print('balance decreased'))
          .catchError(
              (error) => print(error.toString())); //TODO:riktig felhantering
    }
  }

  Future<String> getChosenDeckTheme({required String userId}) async {
    CollectionReference statistics = database.collection('Statistics');
    String returnString = 'Something went wrong';

    await statistics
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          returnString = documentSnapshot['chosenDeck'];
        } on StateError catch (e) {
          print(e);
        }
      }
    });

    return returnString;
  }

  void changeDeckTheme({required String deck, required String userId}) {
    //ändrar standardval på kortlekstema
    CollectionReference statistics = database.collection('Statistics');

    statistics
        .doc(userId)
        .update({'chosenDeck': deck})
        .then((value) => print('chosen deck changed'))
        .catchError(
            (error) => print(error.toString())); //TODO:riktig felhantering
  }

  Future<bool> getUnlockedDeck(
      {required String deck, required String userId}) async {
    CollectionReference statistics = database.collection('Statistics');
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
          print(e);
        }
      }
    });

    return returnBool;
  }

  void unlockDeck({required String deck, required String userId}) {
    CollectionReference statistics = database.collection('Statistics');

    if (deck == 'StarWars') {
      statistics
          .doc(userId)
          .update({'starWarsDeckUnlocked': true})
          .then((value) => print('chosen deck changed'))
          .catchError(
              (error) => print(error.toString())); //TODO:riktig felhantering
    } else if (deck == 'Golden') {
      statistics
          .doc(userId)
          .update({'goldenDeckUnlocked': true})
          .then((value) => print('chosen deck changed'))
          .catchError(
              (error) => print(error.toString())); //TODO:riktig felhantering
    }
  }

  Future<int> getGamesPlayed({required String userId}) async{
    CollectionReference statistics = database.collection('Statistics');
    int returnInt = 0;

    await statistics
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          returnInt = documentSnapshot['gamesPlayed'];
        } on StateError catch (e) {
          print(e);
        }
      }
    });

    return returnInt;

  }

  Future<int> getGamesWon({required String userId}) async{
    CollectionReference statistics = database.collection('Statistics');
    int returnInt = 0;

    await statistics
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          returnInt = documentSnapshot['wins'];
        } on StateError catch (e) {
          print(e);
        }
      }
    });

    return returnInt;

  }

  Future<int> getGamesLost({required String userId}) async{
    CollectionReference statistics = database.collection('Statistics');
    int returnInt = 0;

    await statistics
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          returnInt = documentSnapshot['losses'];
        } on StateError catch (e) {
          print(e);
        }
      }
    });

    return returnInt;

  }

  Future<dynamic> getDrawnCards({required String userId}) async {
    CollectionReference statistics = database.collection('Statistics');
    dynamic returnMap;

    await statistics
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          returnMap = documentSnapshot['spades']['clubs']['hearts']['diamonds'];
        } on StateError catch (e) {
          print(e);
        }
      }
    });

    return returnMap;
  }


}
