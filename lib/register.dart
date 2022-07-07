import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:testapp/LoginPage.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            // alignment: Alignment.center,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: w / 1.5,
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                label: const Text('Name'),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              // controller: _emailController,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: w / 1.5,
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                label: const Text('Email'),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              // controller: _emailController,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: w / 1.5,
                            child: TextFormField(
                              obscureText: true,

                              controller: _passController,
                              decoration: InputDecoration(
                                label: const Text('Password'),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              // controller: _passController,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: w / 1.5,
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                label: const Text('Phone'),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              // controller: _emailController,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              print(_nameController.text);
                              print(_emailController.text);
                              print(_passController.text);
                              print(_phoneController.text);
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passController.text)
                                  .then((userCredential) async {
                                print(userCredential.user!.uid);
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userCredential.user!.uid)
                                    .set({
                                  'uid': userCredential.user!.uid,
                                  'email': userCredential.user!.email,
                                  'photo': userCredential.user!.photoURL,
                                  'name': _nameController.text,
                                  'phone': _phoneController.text,
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Registration succesful'),
                                  ),
                                );
                                Navigator.pop(context);
                              }).onError(
                                (error, stackTrace) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(error.toString()),
                                      duration: const Duration(seconds: 10),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: h * 0.05,
                              width: w * 0.2,
                              color: Colors.orangeAccent,
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Existing user?",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
                                ),
                                TextSpan(
                                    text: "  Login",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.blue,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return const LoginPage();
                                          },
                                        ));
                                      })
                              ],
                            ),
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
