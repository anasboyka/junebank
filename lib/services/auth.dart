import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:junebank/models/user.dart';
import 'package:junebank/services/database.dart';

class AuthService {
  var accountNumber = 123;
  var resultAccount;
  int test;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //String key = "AIzaSyDOhzsl0nJ2HCOy5x5y0VSFz6h80KfzlEc";

  UserFirebase _userFromFirebaseUser(User user) {
    return user != null ? UserFirebase(uid: user.uid) : null;
  }

  Stream<UserFirebase> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future registerWithEmailAndPassword(
      String email, String password, String name, String mobileNo) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      var haveCollection = await FirebaseFirestore.instance
          .collection('account')
          .get()
          .then((value) {
        return value.docs.length;
      });
     

      if (haveCollection > 0) {
        await FirebaseFirestore.instance
            .collection('account')
            .orderBy('accountNumber', descending: true)
            .limit(1)
            .get()
            .then((snapshot) async {
          print(snapshot.docs.first['accountNumber']);
          if (snapshot.docs.first.exists) {
            accountNumber = snapshot.docs.first['accountNumber']+1;
          } else {
            accountNumber = 52213119000;
          }
          
        });
      } else {
        accountNumber = 52213119000;
      }

      await DatabaseService(uid: user.uid).updateUserdata(
          name, accountNumber,"Personal Account-i", 10.0, user.email, password, mobileNo);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } 
    
    on PlatformException catch (err){
      print(err.toString());
      return null;
    }
    on FirebaseAuthException catch (err){
      print(err.toString());
      return null;
    }
    catch (e) {
      print(e.toString());
      return null;
    } 
  }

  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
