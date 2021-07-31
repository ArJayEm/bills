import 'package:bills/pages/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReenterMpin extends StatefulWidget {
  ReenterMpin({Key? key, required this.auth, required this.nominatedPin})
      : super(key: key);

  final FirebaseAuth auth;
  final String nominatedPin;

  @override
  _ReenterMpinState createState() => _ReenterMpinState();
}

class _ReenterMpinState extends State<ReenterMpin> {
  late FirebaseAuth _auth;
  late User _user;
  late DocumentReference _document;
  late String _nominatedPin;
  bool _isLoading = false;

  final _pinControllerFull = TextEditingController();
  final _pinController1 = TextEditingController();
  final _pinController2 = TextEditingController();
  final _pinController3 = TextEditingController();
  final _pinController4 = TextEditingController();
  final _pinController5 = TextEditingController();
  final _pinController6 = TextEditingController();

  final _pinFocusNode1 = FocusNode();
  final _pinFocusNode2 = FocusNode();
  final _pinFocusNode3 = FocusNode();
  final _pinFocusNode4 = FocusNode();
  final _pinFocusNode5 = FocusNode();
  final _pinFocusNode6 = FocusNode();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    setState(() {
      _auth = widget.auth;
      _user = _auth.currentUser!;
      _nominatedPin = widget.nominatedPin;
      _document = FirebaseFirestore.instance.collection('users').doc(_user.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey.shade300),
        backgroundColor: Colors.grey.shade800,
        elevation: 0,
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _getReenterWidget(),
    );
  }

  Widget _getReenterWidget() {
    return SafeArea(
        child: Container(
          color: Colors.grey.shade800,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text('Please Re-enter your nominated 6-digit PIN',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Spacer(),
                  Flexible(
                    child: TextFormField(
                      obscureText: true,
                      controller: _pinController1,
                      focusNode: _pinFocusNode1,
                      autofocus: _pinControllerFull.text.length == 0,
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 0) {
                          _pinController1.text = "";
                          _pinControllerFull.text = "";
                          FocusScope.of(context).requestFocus(_pinFocusNode1);
                          FocusScope.of(context).unfocus();
                        } else if (value.length == 1) {
                          _pinController1.text = value;
                          _pinControllerFull.text =
                              '${_pinControllerFull.text}$value';
                          FocusScope.of(context).requestFocus(_pinFocusNode2);
                        } else {
                          var splittedPin = value.split("");
                          for (var i = 0; i < splittedPin.length; i++) {
                            if (i == 0) {
                              _pinController1.text = splittedPin[i];
                              FocusScope.of(context)
                                  .requestFocus(_pinFocusNode2);
                            }
                            if (i == 1) {
                              _pinController2.text = splittedPin[i];
                              FocusScope.of(context)
                                  .requestFocus(_pinFocusNode3);
                            }
                            if (i == 2) {
                              _pinController3.text = splittedPin[i];
                              FocusScope.of(context)
                                  .requestFocus(_pinFocusNode4);
                            }
                            if (i == 3) {
                              _pinController4.text = splittedPin[i];
                              FocusScope.of(context)
                                  .requestFocus(_pinFocusNode5);
                            }
                            if (i == 4) {
                              _pinController5.text = splittedPin[i];
                              FocusScope.of(context)
                                  .requestFocus(_pinFocusNode6);
                            }
                            if (i == 5) {
                              _pinController6.text = splittedPin[i];
                              _pinControllerFull.text = splittedPin.join();
                              _saveMpin();
                            }
                          }
                        }
                        print('nom pin: ${_pinControllerFull.text}');
                      },
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    child: TextFormField(
                      obscureText: true,
                      controller: _pinController2,
                      focusNode: _pinFocusNode2,
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 0) {
                          _pinController2.text = "";
                          _pinControllerFull.text =
                              _pinControllerFull.text.substring(0, 1);
                          FocusScope.of(context).requestFocus(_pinFocusNode1);
                        } else if (value.length == 1) {
                          _pinController2.text = value;
                          _pinControllerFull.text =
                              '${_pinControllerFull.text}$value';
                          FocusScope.of(context).requestFocus(_pinFocusNode3);
                        } else {
                          String overValue = value.substring(1, 2);
                          value = value.substring(0, 1);
                          _pinController2.text = value;
                          _pinController3.text = overValue;
                          _pinControllerFull.text =
                              '${_pinControllerFull.text}$overValue';
                          FocusScope.of(context).requestFocus(_pinFocusNode4);
                        }
                        print('nom pin: ${_pinControllerFull.text}');
                      },
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    child: TextFormField(
                      obscureText: true,
                      controller: _pinController3,
                      focusNode: _pinFocusNode3,
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 0) {
                          _pinController3.text = "";
                          _pinControllerFull.text =
                              _pinControllerFull.text.substring(0, 2);
                          FocusScope.of(context).requestFocus(_pinFocusNode2);
                        } else if (value.length == 1) {
                          _pinController3.text = value;
                          _pinControllerFull.text =
                              '${_pinControllerFull.text}$value';
                          FocusScope.of(context).requestFocus(_pinFocusNode4);
                        } else {
                          String overValue = value.substring(1, 2);
                          value = value.substring(0, 1);
                          _pinController3.text = value;
                          _pinController4.text = overValue;
                          _pinControllerFull.text =
                              '${_pinControllerFull.text}$overValue';
                          FocusScope.of(context).requestFocus(_pinFocusNode5);
                        }

                        print('nom pin: ${_pinControllerFull.text}');
                      },
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    child: TextFormField(
                      obscureText: true,
                      controller: _pinController4,
                      focusNode: _pinFocusNode4,
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 0) {
                          _pinController4.text = "";
                          _pinControllerFull.text =
                              _pinControllerFull.text.substring(0, 3);
                          FocusScope.of(context).requestFocus(_pinFocusNode3);
                        } else if (value.length == 1) {
                          _pinController4.text = value;
                          _pinControllerFull.text =
                              '${_pinControllerFull.text}$value';
                          FocusScope.of(context).requestFocus(_pinFocusNode5);
                        } else {
                          String overValue = value.substring(1, 2);
                          value = value.substring(0, 1);
                          _pinController4.text = value;
                          _pinController5.text = overValue;
                          _pinControllerFull.text =
                              '${_pinControllerFull.text}$overValue';
                          FocusScope.of(context).requestFocus(_pinFocusNode6);
                        }
                        print('nom pin: ${_pinControllerFull.text}');
                      },
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    child: TextFormField(
                      obscureText: true,
                      controller: _pinController5,
                      focusNode: _pinFocusNode5,
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 0) {
                          _pinController5.text = "";
                          _pinControllerFull.text =
                              _pinControllerFull.text.substring(0, 4);
                          FocusScope.of(context).requestFocus(_pinFocusNode4);
                        } else if (value.length == 1) {
                          _pinController5.text = value;
                          _pinControllerFull.text =
                              '${_pinControllerFull.text}$value';
                          FocusScope.of(context).requestFocus(_pinFocusNode6);
                        } else {
                          String overValue = value.substring(1, 2);
                          value = value.substring(0, 1);
                          _pinController5.text = value;
                          _pinController6.text = overValue;
                          _pinControllerFull.text =
                              '${_pinControllerFull.text}$overValue';
                          FocusScope.of(context).requestFocus(_pinFocusNode6);
                          _saveMpin();
                        }

                        print('nom pin: ${_pinControllerFull.text}');
                      },
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    child: TextFormField(
                      obscureText: true,
                      controller: _pinController6,
                      focusNode: _pinFocusNode6,
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 0) {
                          _pinController6.text = "";
                          _pinControllerFull.text =
                              _pinControllerFull.text.substring(0, 5);
                          FocusScope.of(context).requestFocus(_pinFocusNode5);
                        } else if (value.length == 1) {
                          _pinController6.text = value;
                          _pinControllerFull.text =
                              '${_pinControllerFull.text}$value';
                          FocusScope.of(context).unfocus();
                          _saveMpin();
                        } else {
                          value = value.substring(0, 1);
                          _pinController6.text = value;
                          FocusScope.of(context).unfocus();
                          _saveMpin();
                        }
                        print('nom pin: ${_pinControllerFull.text}');
                      },
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      );
  }

  Future<void> _saveMpin() async {
    setState(() => _isLoading = true);
    String msg = '';

    if (_pinControllerFull.text.length == 6) {
      if (_nominatedPin == _pinControllerFull.text) {
        _document.update(
            {'mpin': _nominatedPin, 'logged_in': true}).whenComplete(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Dashboard(auth: _auth)));
        });
      } else {
        setState(() => _isLoading = false);
        msg = "Pins doesn't match!";
      }
    }

    if (msg.length > 0) {
      Fluttertoast.showToast(msg: msg);
    }
  }
}
