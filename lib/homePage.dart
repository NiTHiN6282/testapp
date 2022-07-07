import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/LoginPage.dart';
import 'package:testapp/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> getUserData() async {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .get();
    currentUserData = doc.data();
    setState((){});
  }

  @override
  void initState() {
    if(currentUserData!['uid'] == null){
      getUserData();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              FirebaseAuth.instance.signOut().then(
                (value) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return LoginPage();
                    },
                  ), (route) => false);
                },
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          )
        ],
      ),
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Text(
            'Welcome ${currentUserData!['name']}',
            style:
                TextStyle(color: Colors.black,
                    fontSize: 30,
                    decoration: TextDecoration.none),
          ),
        ),
      ),
    );
  }
}
