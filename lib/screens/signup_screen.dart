// ignore_for_file: use_build_context_synchronously, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '/screens/login_screen.dart';
import '../httpException.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _cnfpasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _auth = FirebaseAuth.instance;
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Auth>(context, listen: false).authenticateSignup(
            _emailController.text.trim(), _cnfpasswordController.text.trim());
      } on HttpException catch (error) {
        toast(error.message.toString());
      } catch (error) {
        toast(error.toString());
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                  margin: EdgeInsets.only(top: deviceSize.height / 4 / 4 / 4),
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: deviceSize.height / 4 / 4 * .7,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: deviceSize.height / 4 / 4),
                  width: double.infinity,
                  padding: const EdgeInsets.all(1),
                  child: Text(
                    'Signup with Email',
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
                    'Create your account by filling out the form below.',
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
                      controller: _nameController,
                      validator: (value) =>
                          value!.isEmpty ? 'Pḷease enter full name' : null,
                      decoration: const InputDecoration(
                        hintText: 'Full Name',
                        //  border: InputBorder.none,
                      )),
                ),
                SizedBox(height: deviceSize.height / 4 / 4 / 2),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      left: deviceSize.width / 4 / 4 / 4,
                      right: deviceSize.width / 4 / 4 / 4),
                  child: TextFormField(
                      controller: _emailController,
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
                  margin: EdgeInsets.only(
                      left: deviceSize.width / 4 / 4 / 4,
                      right: deviceSize.width / 4 / 4 / 4,
                      top: deviceSize.height / 4 / 4 / 2),
                  child: TextFormField(
                      controller: _cnfpasswordController,
                      validator: (value) => value!.isEmpty
                          ? 'Pḷease enter confirm password'
                          : value != _passwordController.text
                              ? 'confirm password not match'
                              : null,
                      decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                        //  border: InputBorder.none,
                      )),
                ),
                Container(
                    width: double.infinity,
                    height: deviceSize.height / 4 / 4,
                    margin: EdgeInsets.only(
                      top: deviceSize.height / 4 / 4 * .8,
                      left: deviceSize.width / 4 / 4 / 4,
                      right: deviceSize.width / 4 / 4 / 4,
                    ),
                    child: _isLoading == true
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : OutlinedButton(
                            onPressed: () async {
                              await _submit();
                              if (Provider.of<Auth>(context, listen: false)
                                      .isSucess ==
                                  true) {
                                Provider.of<Auth>(context, listen: false)
                                    .username = _nameController.text.trim();
                                Navigator.pop(context);
                                toast('Successfully Signed Up');
                              }
                            },
                            child: Text(
                              'Sign Up',
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
                            'Already Have An Account? ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: deviceSize.height / 4 / 4 / 3),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff900D3E),
                                  fontSize: deviceSize.height / 4 / 4 / 2 * .8),
                            ),
                          ),
                        ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
