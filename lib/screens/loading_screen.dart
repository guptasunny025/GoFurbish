import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

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
                  Color(0xff900D3E).withOpacity(.4),
                  Color(0xff900D3E).withOpacity(.7),
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
            ])));
  }
}
