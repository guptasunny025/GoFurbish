// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../httpException.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var profileData;
  String userId = '';
  String username = '';
  bool isSucess = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<dynamic> authenticateSignup(
    String email,
    dynamic password,
  ) async {
    isSucess = false;
    try {
      final _user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (_user != null) {
        isSucess = true;
        notifyListeners();
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<dynamic> authenticateSignin(
    String email,
    dynamic password,
  ) async {
    isSucess = false;
    try {
      final _user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_user != null) {
        userId = await _user.user!.uid.toString();
        final prefs = await SharedPreferences.getInstance();
        final userData = await json.encode(
          {'userid': userId,
          'username':username
          },
        );
        await prefs.setString('userData', userData);
        isSucess = true;
        notifyListeners();
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  bool isauth = false;
  Future tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return isauth = false;
    }
    if (prefs.containsKey('userData')) {
      final extractedagentUserData = await json
          .decode(prefs.getString('userData') ?? '') as Map<String, dynamic>;
      // final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
      userId = await extractedagentUserData['userid'];
      username=await extractedagentUserData['username'];
      isauth = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    if (await prefs.containsKey('userData')) {
      await prefs.remove('userData');
      await GoogleSignIn().signOut();
      userId = '';
      notifyListeners();
    }
  }
}
