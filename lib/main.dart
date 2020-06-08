import 'package:flutter/material.dart';
import 'package:provider_example/src/pages/home_page.dart';
import 'package:provider_example/src/pages/login_page.dart';
import 'package:provider_example/src/bloc/provider.dart';
import 'package:provider_example/src/pages/product_page.dart';
import 'package:provider_example/src/pages/register_page.dart';
import 'package:provider_example/src/shared/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = UserPreferences();
  await pref.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pref = UserPreferences();

    print(pref.token);
     print(pref.userAuth);


    return Provider(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: pref.userAuth ? 'home' : 'login',
        routes: {
          'login': (BuildContext ctx) => LoginPage(),
          'home': (BuildContext ctx) => HomePage(),
          'product': (BuildContext ctx) => ProductPage(),
          'register': (BuildContext ctx) => RegisterPage()
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}
