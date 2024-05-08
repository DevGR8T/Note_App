import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/pages/homepage.dart';
import 'package:note_app/pages/loginpage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:note_app/services/authservices.dart';
import 'package:sign_in_button/sign_in_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController cpasswordcontroller = TextEditingController();

  bool hidepassword = true;
  bool hidepassword2 = true;
  bool loading = false;
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Form(
            key: formkey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 12),
                  width: size.width,
                  height: size.height / 6,
                  color: Colors.indigo[900],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Text(
                        'Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 35),
                      ),
                      Text(
                        'Create your account',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  height: size.height,
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Name field
                      TextFormField(
                        controller: namecontroller,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == '') {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.black45, width: 1.5)),
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 15),
                      //Email field
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
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
                                color: Colors.black45),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.black45, width: 1.5)),
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
                                color: Colors.black45),
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
                                    color: Colors.black45, width: 1.5)),
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(height: 15),
                      //Confirm passsword field
                      TextFormField(
                        controller: cpasswordcontroller,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == '') {
                            return 'Confirm your password';
                          } else if (value!.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        obscureText: hidepassword2,
                        decoration: InputDecoration(
                            labelText: 'Confirm password',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black45),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidepassword2 = !hidepassword2;
                                  });
                                },
                                icon: Icon(Icons.visibility_off_outlined)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Colors.black45, width: 1.5)),
                            border: OutlineInputBorder()),
                      ),
                      // Register Button
                      Container(
                        margin: EdgeInsets.only(top: 20),
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
                            }
                            if (passwordcontroller.text !=
                                cpasswordcontroller.text) {
                              setState(() {
                                loading = true;
                              });
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  loading = false;
                                });
                              });
                              Future.delayed(Duration(seconds: 1), () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    'Password do not match',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: Colors.red,
                                ));
                              });
                            } else {
                              User? registerresult = await Authservices()
                                  .register(emailcontroller.text,
                                      passwordcontroller.text, context);
                              if (registerresult != null) {
                                setState(() {
                                  loading = true;
                                });
                                Future.delayed(Duration(seconds: 5), () {
                                  setState(() {
                                    loading = false;
                                  });
                                });
                                Future.delayed(Duration(seconds: 5), () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      'Registration complete',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    backgroundColor: Colors.green,
                                  ));
                                });

                                Future.delayed(Duration(seconds: 6), () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
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
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    )),
                                    Text(
                                      '  Please wait...',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 18),
                                    )
                                  ],
                                )
                              : Text(
                                  'Register',
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
                          SizedBox(height: 70),
                          Text(
                            'I have an account?',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                    (route) => false);
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                    fontSize: 20),
                              ))
                        ],
                      ),
                      Divider(),
                      isloading
                          ? CircularProgressIndicator()
                          : SignInButton(
                              Buttons.google,
                              padding: EdgeInsets.only(left: 25),
                              onPressed: () async {
                                setState(() {
                                  isloading = true;
                                });
                                User googleresult = await Authservices()
                                    .signupwithgoogle(context);
                                setState(() {
                                  isloading = false;
                                });

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomePage(
                                        member: googleresult,
                                      ),
                                    ),
                                    (route) => false);
                                setState(() {
                                  isloading = false;
                                });
                              },
                              text: 'Sign up with google',
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
