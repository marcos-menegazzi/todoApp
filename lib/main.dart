import 'package:flutter/material.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/login_screen.dart';
import 'package:myapp/database/db_handler.dart';
import 'package:myapp/models/user_model.dart';

Future selectStartPage() async {
  DBHelper? dbHelper = DBHelper();
  UserModel userModel = await dbHelper.getUser();

  print(userModel.email);

  return userModel.email != null ? '/home': '/login';
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  String defaultHome = await selectStartPage();

  runApp( MaterialApp(
      title: 'App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      initialRoute: defaultHome,
      routes: <String, WidgetBuilder>{
        // Set routes for using the Navigator.
        '/home': (BuildContext context) => const MyHomePage(),
        '/login': (BuildContext context) => const LoginScreen()
      },
    )
  );
}

