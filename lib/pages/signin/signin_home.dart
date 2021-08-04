import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bills/pages/pin/pin_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bills/pages/signin/email.dart';
import 'package:bills/pages/signin/mobile.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/custom_icon_button.dart';

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   // Optional clientId
//   // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
//   scopes: <String>[
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );

enum LoginType { MOBILE_NUMBER, GOOGLE, PIN }

class SignInHome extends StatefulWidget {
  SignInHome({Key? key, required this.auth}) : super(key: key);

  final FirebaseAuth auth;

  @override
  _SignInHomeState createState() => _SignInHomeState();
}

class _SignInHomeState extends State<SignInHome> {
  late FirebaseAuth _auth;
  late User _user;
  var facebookProfile;

  bool _isLoading = false;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _auth = widget.auth;
      //_user = _auth.currentUser!;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade800,
        elevation: 0,
        //toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.grey.shade800,
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : getWelcomeWidget(),
        ),
      ),
    );
  }

  Widget getWelcomeWidget() {
    return ListView(
      children: [
        ListTile(
          title: Text('Welcome back!\nLogin to your account',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        SizedBox(height: 20),
        CustomIconButton(
          color: Colors.deepOrange.shade400,
          textColor: Colors.grey.shade300,
          image: const AssetImage('assets/icons/google.png'),
          text: 'Google',
          onPressed: _signInWithGoogle,
        ),
        CustomIconButton(
          color: Colors.blue,
          textColor: Colors.grey.shade300,
          image: const AssetImage('assets/icons/facebook-256.png'),
          text: 'Facebook',
          onPressed: initiateFacebookLogin,
        ),
        CustomIconButton(
          color: Colors.grey.shade300,
          textColor: Colors.grey.shade800,
          image: const AssetImage('assets/icons/email.png'),
          text: 'Email',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EmailSignInPage(auth: _auth, isSignin: false)));
          },
        ),
        CustomIconButton(
          color: Colors.grey.shade300,
          textColor: Colors.grey.shade800,
          image: const AssetImage('assets/icons/mobile.png'),
          text: 'Mobile Number',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MobileSignInPage(auth: _auth)));
          },
        ),
        SizedBox(height: 20),
        // Row(
        //   children: [
        //     Spacer(),
        //     Text(
        //       'Not yet registered?',
        //       style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
        //     ),
        //     TextButton(
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) =>
        //                     EmailSignInPage(auth: _auth, isSignin: true)));
        //       },
        //       child: Text(
        //         'Sign Up',
        //         style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
        //       ),
        //     ),
        //     Spacer(),
        //   ],
        // ),
        Row(
          children: [
            Spacer(),
            Text(
              'Already registered?',
              style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EmailSignInPage(auth: _auth, isSignin: true)));
              },
              child: Text(
                'Sign In',
                style: TextStyle(color: Colors.grey.shade300, fontSize: 15),
              ),
            ),
            Spacer(),
          ],
        ),
        // GestureDetector(
        //   child: Container(
        //     width: 120,
        //     height: 55,
        //     decoration: BoxDecoration(
        //       //color: Colors.black,
        //       image: DecorationImage(
        //           image: AssetImage("assets/buttons/google_login.png"),
        //           fit: BoxFit.cover),
        //     ),
        //   ),
        //   onTap: _handleSignIn,
        // )
      ],
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _errorMsg = "";
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          setState(() {
            _user = userCredential.user!;
          });
          await _createLoginAccount();
        }
      }
    } on FirebaseAuthException catch (e) {
      _errorMsg = '${e.message}';
    } catch (error) {
      _errorMsg = error.toString();
    }

    setState(() => _isLoading = false);
    if (_errorMsg.length > 0) {
      Fluttertoast.showToast(msg: _errorMsg);
    }
  }

  void initiateFacebookLogin() async {
    setState(() {
      _errorMsg = "";
      _isLoading = true;
    });

    try {
      final FacebookLoginResult result = await FacebookLogin().logIn();
      switch (result.status) {
        case FacebookLoginStatus.error:
          // var values = FacebookLoginStatus.values;
          // print('values: $values');
          _errorMsg = FacebookLoginStatus.error.toString();
          break;
        case FacebookLoginStatus.cancel:
          _errorMsg = FacebookLoginStatus.cancel.toString();
          break;
        case FacebookLoginStatus.success:
          _errorMsg = FacebookLoginStatus.success.toString();

          final facebookAuthCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          UserCredential userCredential =
              await _auth.signInWithCredential(facebookAuthCredential);
          if (userCredential.user != null) {
            setState(() {
              _user = userCredential.user!;
            });
            await _createLoginAccount();
          }

          if (result.accessToken != null) {
            Uri uri = Uri.parse(
                'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${result.accessToken!.token}');
            var graphResponse = await http.get(uri);
            var profile = json.decode(graphResponse.body);
            setState(() {
              _user = userCredential.user!;
            });
            await _createLoginAccount();
            print(profile.toString());
          }
          break;
      }
    } on FirebaseAuthException catch (e) {
      _errorMsg = '${e.message}';
    } catch (error) {
      _errorMsg = error.toString();
    }

    setState(() => _isLoading = false);
    if (_errorMsg.length > 0) {
      Fluttertoast.showToast(msg: _errorMsg);
    }
  }

  Future<void> _createLoginAccount() async {
    setState(() {
      _errorMsg = "";
      _isLoading = true;
    });

    try {
      CollectionReference _collection =
          FirebaseFirestore.instance.collection('users');

      DocumentReference _document = _collection.doc(_user.uid);
      String displayName = _user.displayName ?? _user.email ?? '';
      _document.get().then((snapshot) {
        if (!snapshot.exists) {
          _document.set({
            'display_name': displayName,
            'email': _user.email,
            'photo_url': _user.photoURL,
            'logged_in': false
          }).then((value) {
            _errorMsg = "User added";
          }).catchError((error) {
            _errorMsg = "Failed to add user: $error";
          });
        } else {
          _document.update({'display_name': displayName});
        }
      }).whenComplete(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PinHome(auth: _auth, displayName: displayName),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      _errorMsg = e.toString();
    } catch (e) {
      _errorMsg = e.toString();
    }

    setState(() => _isLoading = false);
    if (_errorMsg.length > 0) {
      Fluttertoast.showToast(msg: _errorMsg);
    }
  }
}