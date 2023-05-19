// ignore_for_file: sort_child_properties_last, use_build_context_synchronously
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:olx_app/screens/bottomnavigation_screen.dart';
import 'package:olx_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/screens/signup_screen.dart';
import '../httpException.dart';
import '../provider/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isLoading = false;
  final _passwordController = TextEditingController();
  final _emailcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false).authenticateSignin(
            _emailcontroller.text.trim(), _passwordController.text.trim());
      } on HttpException catch (error) {
        toast(error.toString());
      } catch (error) {
        toast(error.toString());
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(
              left: deviceSize.width / 4 / 4 / 2,
              right: deviceSize.width / 4 / 4 / 2),
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: deviceSize.height / 4 / 4),
                  width: double.infinity,
                  padding: const EdgeInsets.all(1),
                  child: Text(
                    'Login with Email',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: deviceSize.height / 4 / 4 * .6),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: deviceSize.height / 4 / 4 / 4),
                  width: double.infinity,
                  padding: const EdgeInsets.all(1),
                  child: Text(
                    'Log in with the data that you entered during your registration.',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: deviceSize.height / 4 / 4 / 3),
                  ),
                ),
                SizedBox(height: deviceSize.height / 4 / 4 / 2),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      left: deviceSize.width / 4 / 4 / 4,
                      right: deviceSize.width / 4 / 4 / 4),
                  child: TextFormField(
                      controller: _emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.isEmpty ? 'Pḷease enter email' : null,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        //  border: InputBorder.none,
                      )),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      left: deviceSize.width / 4 / 4 / 4,
                      right: deviceSize.width / 4 / 4 / 4,
                      top: deviceSize.height / 4 / 4 / 2),
                  child: TextFormField(
                      controller: _passwordController,
                      validator: (value) =>
                          value!.isEmpty ? 'Pḷease enter password' : null,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        //  border: InputBorder.none,
                      )),
                ),
                Container(
                    width: double.infinity,
                    height: deviceSize.height / 4 / 4,
                    margin: EdgeInsets.only(
                      top: deviceSize.height / 4 / 4 / 2,
                      left: deviceSize.width / 4 / 4 / 4,
                      right: deviceSize.width / 4 / 4 / 4,
                    ),
                    child: isLoading == true
                        ? const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          )
                        : OutlinedButton(
                            onPressed: () async {
                              await _submit();
                              if (Provider.of<Auth>(context, listen: false)
                                      .isSucess ==
                                  true) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNavigationScreen(
                                              index: 0,
                                            )),
                                    (Route<dynamic> route) => false);
                              }
                            },
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: deviceSize.height / 4 / 4 / 3),
                            )),
                    decoration: BoxDecoration(
                        color: const Color(0xff900D3E),
                        borderRadius: BorderRadius.circular(5))),
                Container(
                    width: double.infinity,
                    height: deviceSize.height / 4 / 4,
                    margin: EdgeInsets.only(top: deviceSize.height / 4 / 4 / 2, left: deviceSize.width / 4 / 4 / 4,
                      right: deviceSize.width / 4 / 4 / 4,),
                    child: OutlinedButton(
                        onPressed: () async {
                          try {
                            GoogleSignInAccount? googleSignInAccount =
                                await _googleSignIn.signIn();
                            GoogleSignInAuthentication
                                googleSignInAuthentication =
                                await googleSignInAccount!.authentication;
                            AuthCredential credential =
                                await GoogleAuthProvider.credential(
                              accessToken:
                                  googleSignInAuthentication.accessToken,
                              idToken: googleSignInAuthentication.idToken,
                            );
                            final UserCredential authResult =
                                await _auth.signInWithCredential(credential);
                            if (authResult != null) {
                              Provider.of<Auth>(context, listen: false).userId =
                                  await authResult.user!.uid.toString();
                              final prefs =
                                  await SharedPreferences.getInstance();
                                  
                              final userData = await json.encode(
                                {
                                  'userid':
                                      await authResult.user!.uid.toString(),
                                  'username':
                                     await authResult.user!.displayName.toString()
                                },
                              );
                              await prefs.setString('userData', userData);
                              if (Provider.of<Auth>(context, listen: false)
                                      .userId !=
                                  '') {
                                    Provider.of<Auth>(context, listen: false)
                                      .username=await authResult.user!.displayName.toString();
                                      print(Provider.of<Auth>(context, listen: false)
                                      .username);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BottomNavigationScreen(
                                              index: 0,
                                            )),
                                    (Route<dynamic> route) => false);
                              }
                            }
                          } catch (e) {
                            toast(e.toString());
                          }
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(FontAwesomeIcons.google,
                                  color: Colors.white),
                              SizedBox(
                                width: deviceSize.width / 4 / 4 / 2,
                              ),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: deviceSize.height / 4 / 4 / 3),
                              )
                            ])),
                    decoration: BoxDecoration(
                        color: const Color(0xFF4284F3),
                        borderRadius: BorderRadius.circular(5))),
                Container(
                    width: double.infinity,
                    //height: deviceSize.height / 4 / 4,
                    //  alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        top: deviceSize.height / 4 / 4 / 2,
                        left: deviceSize.width / 4 / 4,
                        right: deviceSize.width / 4 / 4),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Haven\'t registered yet?  ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: deviceSize.height / 4 / 4 / 3),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (ctx) {
                                return const SignUpScreen();
                              }));
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff900D3E),
                                  fontSize: deviceSize.height / 4 / 4 / 2 * .8),
                            ),
                          ),
                        ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void toast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 100,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0);
}
