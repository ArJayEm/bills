import 'package:bills/helpers/extensions/format_extension.dart';
//import 'package:bills/models/members.dart';
import 'package:bills/models/user_profile.dart';
import 'package:bills/pages/dashboard.dart';
import 'package:bills/pages/signin/pin/enter.dart';
//import 'package:bills/pages/signin/pin/enter.dart';
//import 'package:bills/pages/signin/email.dart';
import 'package:bills/pages/signin/signin_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class PinHome extends StatefulWidget {
  const PinHome({Key? key, required this.auth, required this.displayName})
      : super(key: key);

  final FirebaseAuth auth;
  final String displayName;

  @override
  _PinHomeState createState() => _PinHomeState();
}

class _PinHomeState extends State<PinHome> {
  late FirebaseAuth _auth;
  final FirebaseFirestore _ffInstance = FirebaseFirestore.instance;
  late String _displayName;

  final List _mpinButtons = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '',
    '0',
    '<'
  ];

  final _pinController = TextEditingController();
  bool _pinControllerLen1 = false;
  bool _pinControllerLen2 = false;
  bool _pinControllerLen3 = false;
  bool _pinControllerLen4 = false;
  bool _pinControllerLen5 = false;
  bool _pinControllerLen6 = false;
  bool _showBackSpace = false;

  bool _isLoading = false;
  final bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _auth = widget.auth;
      _displayName = widget.displayName;
    });
    //_checkIfExistingUser();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor:
            Colors.grey.shade300, // Color.fromARGB(255, 0, 125, 253),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.grey.shade300, // Color.fromARGB(255, 0, 125, 253),
          child: getEnterMpinWidget(),
        ),
      ),
    );
  }

  Widget getEnterMpinWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_auth.currentUser!.photoURL != null)
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          _auth.currentUser!.photoURL.toString(),
                        ),
                      ),
                    ),
                  ),
                if (_auth.currentUser!.photoURL != null)
                  const SizedBox(width: 5),
                SizedBox(
                  //width: 150,
                  child: Text(
                    _displayName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () => showDialog<String>(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Are you sure you want to logout?'),
                  content: const Text(
                      'Your account will be removed from the device.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () async {
                        _handleSignOut();
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              ),
              child: Text(
                'Switch Account',
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _pinControllerLen1 || _pinController.text.isNotEmpty
                ? Icon(Icons.circle, color: Colors.grey.shade800, size: 15)
                : Icon(Icons.circle_outlined,
                    color: Colors.grey.shade800, size: 15),
            _pinControllerLen2 || _pinController.text.length >= 2
                ? Icon(Icons.circle, color: Colors.grey.shade800, size: 15)
                : Icon(Icons.circle_outlined,
                    color: Colors.grey.shade800, size: 15),
            _pinControllerLen3 || _pinController.text.length >= 3
                ? Icon(Icons.circle, color: Colors.grey.shade800, size: 15)
                : Icon(Icons.circle_outlined,
                    color: Colors.grey.shade800, size: 15),
            _pinControllerLen4 || _pinController.text.length >= 4
                ? Icon(Icons.circle, color: Colors.grey.shade800, size: 15)
                : Icon(Icons.circle_outlined,
                    color: Colors.grey.shade800, size: 15),
            _pinControllerLen5 || _pinController.text.length >= 5
                ? Icon(Icons.circle, color: Colors.grey.shade800, size: 15)
                : Icon(Icons.circle_outlined,
                    color: Colors.grey.shade800, size: 15),
            _pinControllerLen6 || _pinController.text.length >= 6
                ? Icon(Icons.circle, color: Colors.grey.shade800, size: 15)
                : Icon(Icons.circle_outlined,
                    color: Colors.grey.shade800, size: 15),
          ],
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Enter your PIN',
            style: TextStyle(color: Colors.grey.shade800),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 450,
          //height: 400,
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
            shrinkWrap: true,
            //physics: BouncingScrollPhysics(),
            itemCount: _mpinButtons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1,
                crossAxisCount: 3,
                //mainAxisExtent: 80,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (BuildContext context, int index) {
              return _mpinButtons[index].length > 0 &&
                      _mpinButtons[index] != '<'
                  ? FloatingActionButton(
                      onPressed: () {
                        if (!_isLoading) {
                          if (_pinController.text.length < 6) {
                            _pinController.text =
                                '${_pinController.text}${_mpinButtons[index]}';
                            _setBoolean();
                            if (_pinController.text.length == 6) {
                              _verifyMpin();
                            }
                          } else if (_pinController.text.length == 6) {
                            _verifyMpin();
                          }
                          _buttonPressed(index);
                        }
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade700, width: 1.5),
                          borderRadius: BorderRadius.circular(35),
                          color: _isLoading
                              ? Colors.grey.shade700
                              : Colors.grey.shade800,
                        ),
                        child: Center(
                          child: Text(
                            '${_mpinButtons[index]}',
                            style: TextStyle(
                              fontSize: 30,
                              color: _isButtonPressed
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                    )
                  : _mpinButtons[index].toString() == '<'
                      ? _showBackSpace == true
                          ? GestureDetector(
                              onTap: () {
                                if (!_isLoading) {
                                  if (_pinController.text.isNotEmpty) {
                                    _pinController.text = _pinController.text
                                        .substring(
                                            0, _pinController.text.length - 1);
                                    _setBoolean();
                                  }
                                }
                              },
                              onLongPress: () {
                                if (_pinController.text.isNotEmpty) {
                                  for (var i = 0;
                                      i < _pinController.text.length + 1;
                                      i++) {
                                    _pinController.text = _pinController.text
                                        .substring(
                                            0, _pinController.text.length - 1);
                                  }
                                  _setBoolean();
                                }
                              },
                              child: Center(
                                child: Icon(
                                  Icons.backspace,
                                  color: _isLoading
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade800,
                                  size: 35,
                                ),
                              ),
                            )
                          : const SizedBox()
                      : const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  _buttonPressed(index) {
    // setState(() {
    //   //_isButtonPressed = true;
    // });
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   setState(() {
    //     _isButtonPressed = false;
    //   });
    // });
  }

  _setBoolean() {
    setState(() {
      _pinControllerLen1 = _pinController.text.length == 1;
      _pinControllerLen2 = _pinController.text.length == 2;
      _pinControllerLen3 = _pinController.text.length == 3;
      _pinControllerLen4 = _pinController.text.length == 4;
      _pinControllerLen5 = _pinController.text.length == 5;
      _pinControllerLen6 = _pinController.text.length == 6;

      _showBackSpace = _pinController.text.isNotEmpty;
    });
  }

  Future<void> _verifyMpin() async {
    _showProgressUi(true, "");
    try {
      DocumentReference _document = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid);
      String mpin = '';

      _document.get().then((snapshot) {
        if (snapshot.exists) {
          mpin = snapshot.get("pin") as String;
        }
      }).whenComplete(() {
        if (mpin == _pinController.text) {
          _document.update({'logged_in': true});
          _document
              .update({'last_logged_in': DateTime.now().toIso8601String()});
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Dashboard(auth: _auth)));
        } else {
          setState(() {
            _pinController.text = "";
            _pinControllerLen6 = false;
          });
          _showProgressUi(false, "Incorrect pin.");
        }
      });
    } on FirebaseAuthException catch (e) {
      _showProgressUi(false, e.message.toString());
    } catch (e) {
      _showProgressUi(false, e.toString());
    }
  }

  Future<void> _checkIfExistingUser() async {
    _showProgressUi(true, "");
    try {
      DocumentReference _document =
          _ffInstance.collection('users').doc(_auth.currentUser!.uid);
      UserProfile userProfile = UserProfile();

      _document.get().then((snapshot) {
        if (snapshot.exists) {
          userProfile =
              UserProfile.fromJson(snapshot.data() as Map<String, dynamic>);
          userProfile.mapMembers();
          userProfile.id = snapshot.id;
        } else {
          _auth.signOut();
          _showProgressUi(false, "User not found.");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SignInHome(auth: _auth)));
        }
      }).whenComplete(() {
        setState(() {
          _displayName =
              "${userProfile.phoneNumber ?? userProfile.email ?? userProfile.name}";
        });
        var ll = userProfile.lastLoggedIn ?? DateTime.now();
        var timeOut = ll.add(const Duration(minutes: 10));
        var isLoggedIn = (userProfile.loggedIn ?? false) || DateTime.now().isBefore(timeOut);

        if (userProfile.pin.isNullOrEmpty()) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EnterMpin(
                      auth: _auth, isChange: false, nominatedPin: '')));
        }

        if (isLoggedIn) {
          userProfile.lastLoggedIn = DateTime.now();
          _document.update(
              {"last_logged_in": userProfile.lastLoggedIn?.toIso8601String()});
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Dashboard(auth: _auth)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PinHome(auth: _auth, displayName: _displayName)));
        }

        _showProgressUi(false, "");
      });
    } on FirebaseAuthException catch (e) {
      _showProgressUi(false, "${e.message}.");
    } catch (e) {
      _showProgressUi(false, "$e.");
    }
  }

  _handleSignOut() async {
    _showProgressUi(true, "");

    try {
      _auth.signOut();
      _googleSignIn.disconnect();
      FacebookLogin().logOut();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInHome(auth: _auth),
          //builder: (context) => EmailSignInPage(auth: _auth, isSignin: true),
        ),
      );
    } catch (e) {
      _showProgressUi(false, "$e.");
    }
  }

  _showProgressUi(bool isLoading, String msg) {
    if (msg.isNotEmpty) {
      Fluttertoast.showToast(msg: msg);
    }
    setState(() => _isLoading = isLoading);
  }
}
