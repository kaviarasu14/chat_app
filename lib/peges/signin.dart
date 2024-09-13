import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_flutter/peges/home.dart';
import 'package:demo_flutter/service/database.dart';
import 'package:demo_flutter/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:demo_flutter/peges/forgotpassword.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  String email = "", password = "", name = "", pic = "", id = "", username = "";
  TextEditingController useremail = TextEditingController();
  TextEditingController userpassword = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  userlogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      QuerySnapshot querySnapshot =
          await Databasemethod().getUserbyemail(email);
      name = "${querySnapshot.docs[0]["Name"]}";
      username = "${querySnapshot.docs[0]["username"]}";
      pic = "${querySnapshot.docs[0]["photo"]}";
      id = querySnapshot.docs[0].id;

      await sharedpreferenceHelper().saveUserDisplayname(name);
      await sharedpreferenceHelper().saveUserName(username);
      await sharedpreferenceHelper().saveUserId(id);
      await sharedpreferenceHelper().saveUserPic(pic);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No user found for that Email ",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "wrong password provided by user ",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: [
                Container(
                    height: height / 4.1,
                    width: width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF7f30fe), Color(0xFF6380fb)],
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(width, 105.0)))),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 55),
                      child: Center(
                        child: Text(
                          "Signin",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      //     Center(
                      //     child: Text(
                      //   "Login to your account",
                      //   style: TextStyle(
                      //     color: Color(0xFFbbb0ff),
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // )),
                    ),
                    Center(
                        child: Text(
                      "Login to your account",
                      style: TextStyle(
                        color: Color(0xFFbbb0ff),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsetsDirectional.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          margin: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 7.0),
                          height: height / 2.2,
                          width: width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                    // padding: EdgeInsets.only(left: 10.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0, color: Colors.black38),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextFormField(
                                      controller: useremail,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter a mail";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.mail_outlined,
                                            color: Color(0xFF7f30fe),
                                          )),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    "Password",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                    // padding: EdgeInsets.only(left: 10.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.0, color: Colors.black38),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextFormField(
                                      controller: userpassword,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter password";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: Color(0xFF7f30fe),
                                          )),
                                      obscureText: true,
                                    )),
                                SizedBox(
                                  height: 20.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Forgotpassword()));
                                  },
                                  child: Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      "Forget Password?",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_formkey.currentState!.validate()) {
                                      setState(() {
                                        email = useremail.text;
                                        password = userpassword.text;
                                      });
                                    }
                                    userlogin();
                                  },
                                  child: Center(
                                    child: SizedBox(
                                      width: 130,
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Color(0xFF7f30fe),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              "Signin",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        Text(
                          " Sign Up Now",
                          style:
                              TextStyle(color: Color(0xFF7f30fe), fontSize: 20),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
