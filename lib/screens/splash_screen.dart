import 'dart:async';
import 'package:flutter/material.dart';
import 'package:olx_app/screens/bottomnavigation_screen.dart';
import 'package:provider/provider.dart';
import '/provider/auth.dart';
import '/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 2;

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

//https://newtestserver.com/dev/fysiolink/therapist-initiate-order-paysera-webview/558
  void navigationPage() {
    Provider.of<Auth>(context, listen: false).isauth == true
        ? Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const BottomNavigationScreen(
                      index: 0,
                    )))
        : Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const LoginScreen()));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _loadWidget();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        // backgroundColor: Color(0xFF198A6F),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            // color: Color(#198A6F),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // stops: [0.0, 0.7, 1.0],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xff900D3E).withOpacity(.7),
                  Color(0xff900D3E).withOpacity(.8),
                  Color(0xff900D3E),
                ],
              ),
            ),
            //  alignment: Alignment.center,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    width: deviceSize.width / 2 * .6,
                    height: deviceSize.height / 4 * .6 * .9,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff900D3E).withOpacity(.8)),
                    child: Text(
                      'GoFurbish',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: deviceSize.height / 4 / 4 / 2 * .8),
                    )),
              ),
            ])

            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //       image: AssetImage('assets/splash.png'), fit: BoxFit.fitWidth),
            // ),
            ));
  }
}
