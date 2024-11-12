import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laptrinhflutterappdoan/components/my_button.dart';
import 'package:laptrinhflutterappdoan/components/my_textfield.dart';
import '../helper/helper_function.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  void RegisterUser() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (passwordController.text != confirmPwController.text) {
      Navigator.pop(context);
      displayMessageToUser("Passwords don't match!", context);
    } else {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );

        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        displayMessageToUser(e.code, context);
      }
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

                MyTextField(
                    hintText: "Username",
                    obscureText: false,
                    controller: usernameController
                ),

                SizedBox(height: 10),

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

                MyTextField(
                    hintText: "Confirm Password",
                    obscureText: true,
                    controller: confirmPwController
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
                  text: 'Register',
                  onTap: RegisterUser,
                ),

                SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(" Login Here",
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