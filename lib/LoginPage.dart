import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testapp/homePage.dart';
import 'package:testapp/register.dart';

String uId = '';

TextEditingController emailController = TextEditingController();

Map<String, dynamic>? currentUserData = {};

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passController = TextEditingController();

  signUpWithGoogle() async {
    GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? gAuth = await gUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth?.accessToken, idToken: gAuth?.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    uId = userCredential.user!.uid;
    var userName = userCredential.user?.displayName;
    var userImage = userCredential.user?.photoURL;
    var userEmail = userCredential.user?.email;
    FirebaseFirestore.instance.collection('users').doc(uId).set(
      {
        'uid': uId,
        'name': userName,
        'email': userEmail,
        'photo': userImage,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          // height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Hello',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Form(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.center,
                              width: w / 1.5,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  label: const Text('Email'),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                controller: emailController,
                              )),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: w / 1.5,
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                label: const Text('Password'),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              controller: _passController,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Forgot Password?",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Colors.red),
                                            ),
                                            content: GestureDetector(
                                              onTap: () {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              child: Container(
                                                height: 150,
                                                width: 300,
                                                child: ListView(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          emailController,
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Email'),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "cancel",
                                                            )),
                                                        SizedBox(
                                                          width: 35,
                                                        ),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              FocusManager
                                                                  .instance
                                                                  .primaryFocus
                                                                  ?.unfocus();
                                                              FirebaseAuth
                                                                  .instance
                                                                  .sendPasswordResetEmail(
                                                                      email: emailController
                                                                          .text)
                                                                  .then((value) =>
                                                                      Navigator.pop(
                                                                          context))
                                                                  .onError((error,
                                                                      stackTrace) {
                                                                Navigator.pop(
                                                                    context);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(SnackBar(
                                                                        content:
                                                                            Text(error.toString())));
                                                              });
                                                            },
                                                            child: Text(
                                                              "Reset",
                                                            )),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Text("Forgot Password?")),
                            ],
                          ),
                          const SizedBox(height: 30),
                          GestureDetector(
                            onTap: () {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailController.text,
                                      password: _passController.text)
                                  .then(
                                (userCredential) async {
                                  print(userCredential.user!.uid);

                                  DocumentSnapshot<Map<String, dynamic>> doc =
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userCredential.user!.uid)
                                          .get();
                                  currentUserData = doc.data();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                  );
                                },
                              ).onError(
                                (error, stackTrace) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(error.toString())));
                                  }
                                },
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: h * 0.05,
                              width: w * 0.2,
                              color: Colors.orangeAccent,
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Don't have an account?",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                                TextSpan(
                                  text: "  Register",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.blue,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Register(),
                                        ),
                                      );
                                    },
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Text('Or'),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  print("Google SignIn");
                                  signUpWithGoogle();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/'
                                        'Google_%22G%22_Logo.svg/2048px-Google_%22G%22_Logo.svg.png'),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                  onTap: () {
                                    print("facebook");
                                  },
                                  child: const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/"
                                        "Facebook_icon.svg/384px-Facebook_icon.svg.png?20140711185505"),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
