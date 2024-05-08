import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/pages/homepage.dart';
import 'package:note_app/pages/registerpage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:note_app/services/authservices.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  bool hidepassword = true;
  bool hidepassword2 = true;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 12),
                  width: size.width,
                  height: size.height / 3,
                  color: Colors.indigo[900],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 180),
                      Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 35),
                      ),
                      Text(
                        'Log into your account',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size.height,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        //Email field
                        TextFormField(
                          controller: emailcontroller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == '') {
                              return 'Please enter your email';
                            } else if (!EmailValidator.validate(value!)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.5)),
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(height: 15),
                        // Password field
                        TextFormField(
                          controller: passwordcontroller,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == '') {
                              return 'Enter a password';
                            } else if (value!.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                          obscureText: hidepassword,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidepassword = !hidepassword;
                                    });
                                  },
                                  icon: Icon(hidepassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.5)),
                              border: OutlineInputBorder()),
                        ),
                        // Login Button
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          width: size.width / 1.1,
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              if (formkey.currentState!.validate() == false) {
                                setState(() {
                                  loading = false;
                                });
                                return null;
                              } else {
                                User? loginresult = await Authservices().login(
                                    emailcontroller.text,
                                    passwordcontroller.text,
                                    context);
                                if (loginresult != null) {
                                  setState(() {
                                    loading = true;
                                  });
                                  Future.delayed(Duration(seconds: 5), () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        'Welcome! Login successful',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.green,
                                    ));
                                  });
                                  Future.delayed(Duration(seconds: 6), () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(
                                            member: loginresult,
                                          ),
                                        ),
                                        (route) => false);
                                  });
                                }
                              }
                              Future.delayed(Duration(seconds: 5), () {
                                setState(() {
                                  loading = false;
                                });
                              });
                            },
                            child: loading
                                ? CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18),
                                  ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 100),
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterPage(),
                                      ),
                                      (route) => false);
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo,
                                      fontSize: 20),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
