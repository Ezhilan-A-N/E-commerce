import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/home_page.dart';
import 'package:e_commerce/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
          //Connection Initialized- FB is Running
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot){
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }
              //Connection State active - USer Login check inside active
              if(streamSnapshot.connectionState == ConnectionState.active){

                User _user = streamSnapshot.data;

                //Not Logged in
                if(_user == null) {
                  return LoginPage();
                }
                else{
                 //User Logged in
                  return HomePage();
                }
              }

              //Checking the auth state- loading
              return Scaffold(
                body: Center(
                  child: Text(
                    "Checking Authentication...",
                    style: Constants.regularHeading,
                  ),
                ),
              );
            },
          );
        }
      //Connecting to FB -Loading
        return Scaffold(
          body: Center(
            child: Text(
              "Initialization App...",
              style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}
