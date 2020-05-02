import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplementation
{
  Future<void> logout();
  Future<String> SignIn(String email, String password);
  Future<String> SignUp(String email, String password);
  Future<String> getCurrentUser();


}

class Auth implements AuthImplementation
{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> SignIn(String email, String password) async
  {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }


  Future<String> SignUp(String email, String password) async
  {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  Future<String> getCurrentUser() async
  {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> logout() async
  {
    _firebaseAuth.signOut();
  }


}