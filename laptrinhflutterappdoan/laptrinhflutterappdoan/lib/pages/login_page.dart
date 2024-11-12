import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laptrinhflutterappdoan/components/my_button.dart';
import 'package:laptrinhflutterappdoan/components/my_textfield.dart';
import 'package:laptrinhflutterappdoan/helper/helper_function.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void Login() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
      );
      if (context.mounted) Navigator.pop(context);
    }

    on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: 80,
                  color: Colors.white,
                ),

                SizedBox(height: 25),

                Text('C A N H B A O C H A Y',
                  style: TextStyle(fontSize: 20, color: Colors.white)),

                SizedBox(height: 50),

                // email user
                MyTextField(
                    hintText: "Email",
                    obscureText: false,
                    controller: emailController
                ),

                SizedBox(height: 10),

                // password user
                MyTextField(
                    hintText: "Password",
                    obscureText: true,
                    controller: passwordController
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Forgot Password?',
                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                SizedBox(height: 25),

                MyButton(
                    text: 'Login',
                    onTap: Login,
                ),

                SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(" Register Here",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black45
                        )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
