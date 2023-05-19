import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/provider/auth.dart';
import '/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'screens/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth())
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
             theme: ThemeData(fontFamily: 'Montserrat',),
            title: 'GoFurbish',
            home: auth.userId == ''
                ? FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) {
                      if (authResultSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const LoadingScreen();
                      }
                      return const SplashScreen();
                    })
                :const SplashScreen(),
            debugShowCheckedModeBanner: false,
          ),
        ));
  }
}

