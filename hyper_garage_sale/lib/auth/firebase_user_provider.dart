import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class HyperGarageSaleFirebaseUser {
  HyperGarageSaleFirebaseUser(this.user);
  User user;
  bool get loggedIn => user != null;
}

HyperGarageSaleFirebaseUser currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<HyperGarageSaleFirebaseUser> hyperGarageSaleFirebaseUserStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<HyperGarageSaleFirebaseUser>(
            (user) => currentUser = HyperGarageSaleFirebaseUser(user));
