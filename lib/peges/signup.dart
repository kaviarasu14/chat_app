import 'package:demo_flutter/peges/chatpage.dart';
import 'package:demo_flutter/peges/home.dart';
import 'package:demo_flutter/service/database.dart';
import 'package:demo_flutter/service/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:demo_flutter/service/database.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email = "",
      name = "",
      password = "",
      confirmpassword = "",
      _password1 = "";
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  regiestration() async {
    if (password == confirmpassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        String Id = randomAlphaNumeric(10);
        String user = emailcontroller.text.replaceAll("@gmail.com", "");
        String updateusername =
            user.replaceFirst(user[0], user[0].toUpperCase());
        String firstletter = user.substring(0, 1).toUpperCase();

        Map<String, dynamic> userInfoMap = {
          "Name": namecontroller.text,
          "E-mail": emailcontroller.text,
          "username": updateusername.toUpperCase(),
          "searchkey": firstletter,
          "photo":
              "https://clipground.com/images/boy-icon-png-7.jpg", // ('https://picsum.photos/250?image=9'),
          "Id": Id,
        };
        await Databasemethod().addUserDetails(userInfoMap, Id);
        await sharedpreferenceHelper().saveUserId(Id);
        await sharedpreferenceHelper().saveUserDisplayname(namecontroller.text);
        await sharedpreferenceHelper().saveUserEmail(emailcontroller.text);
        await sharedpreferenceHelper()
            .saveUserPic('https://clipground.com/images/boy-icon-png-7.jpg');
        await sharedpreferenceHelper().saveUserName(
            emailcontroller.text.replaceAll("@gmail.com", "").toUpperCase());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Registered successfully",
          style: TextStyle(fontSize: 20),
        )));

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "provided password is too weak",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "email already in exists",
                style: TextStyle(fontSize: 18.0),
              )));
        }
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
                          "SignUp",
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
                      "create a new  account",
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
                          vertical: 20.0, horizontal: 12.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsetsDirectional.symmetric(
                              vertical: 20.0, horizontal: 20.0),
                          margin: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 7.0),
                          height: height / 1.6,
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
                                  "Name",
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
                                      controller: namecontroller,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter a Name";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: Color(0xFF7f30fe),
                                          )),
                                    )),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Email",
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
                                      controller: emailcontroller,
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
                                      controller: passwordcontroller,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter a password";
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
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    "Confirm Password",
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
                                      controller: confirmpasswordcontroller,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please confirm the password";
                                        }
                                        return null;
                                      },
                                      // keyboardType: TextInputType.visiblePassword,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: Color(0xFF7f30fe),
                                          )),
                                      obscureText: true,
                                    )),
                                // Container(
                                //   alignment: Alignment.topRight,
                                //   child: Text(
                                //     "Forget Password?",
                                //     style: TextStyle(
                                //         color: Colors.black,
                                //         fontWeight: FontWeight.bold),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 30.0,
                                // ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Text(
                                //       "Don't have an account?",
                                //       style: TextStyle(
                                //           color: Colors.black, fontSize: 20),
                                //     ),
                                //     Text(
                                //       " Sign Up Now",
                                //       style: TextStyle(
                                //           color: Color(0xFF7f30fe),
                                //           fontSize: 20),
                                //     )
                                //   ],
                                // ),

                                SizedBox(
                                  height: 50.0,
                                ),
                                // Center(
                                //   child: Container(
                                //     width: 130,
                                //     child: Material(
                                //       elevation: 5.0,
                                //       borderRadius: BorderRadius.circular(10),
                                //       child: Container(
                                //         padding: EdgeInsets.all(5),
                                //         decoration: BoxDecoration(
                                //             color: Color(0xFF7f30fe),
                                //             borderRadius:
                                //                 BorderRadius.circular(10)),
                                //         child: Center(
                                //           child: Text(
                                //             "Signin",
                                //             style: TextStyle(
                                //                 color: Colors.white,
                                //                 fontWeight: FontWeight.bold,
                                //                 fontSize: 25),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            email = emailcontroller.text;
                            name = namecontroller.text;
                            password = passwordcontroller.text;
                            confirmpassword = confirmpasswordcontroller.text;
                          });
                          // Navigator.pushReplacement(context,
                          //     MaterialPageRoute(builder: (context) => chatpage()));
                        }
                        regiestration();
                      },
                      child: Center(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 10.0, left: 10.0),
                          child: SizedBox(
                            width: width,
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Color(0xFF7f30fe),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "Signup",
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
                      ),
                    )
                    // SizedBox(
                    //   height: 25.0,
                    // ),
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         "Don't have an account?",
                    //         style: TextStyle(color: Colors.black, fontSize: 20),
                    //       ),
                    //       Text(
                    //         " Sign Up Now",
                    //         style:
                    //             TextStyle(color: Color(0xFF7f30fe), fontSize: 20),
                    //       )
                    //     ],
                    //   )
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
