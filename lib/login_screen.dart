import 'package:flutter/material.dart';
import 'package:myapp/database/db_handler.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/models/user_model.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  DBHelper? dbHelper;
  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
            'Login Page',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: 1
            )
        ),
        centerTitle: true,
        elevation: 0
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(children: [
            Form(
              key: _fromKey,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: emailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "E-mail"
                    ),
                    validator: (value) {
                      if(value!.isEmpty) {
                        return "Digite o e-mail";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if(_fromKey.currentState!.validate()) {
                            dbHelper!.login(UserModel(
                              name: 'algum usuário',
                              email: emailController.text,
                              authToken: 'algum token'
                            ));

                            Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
                            emailController.clear();
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),
                )
              ],),
            )
          ],),
        ),
      ),
    );
  }
}