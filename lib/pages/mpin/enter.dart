import 'package:bills/pages/mpin/reenter.dart';
import 'package:bills/pages/signin/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EnterMpin extends StatefulWidget {
  EnterMpin({Key? key, required this.auth}) : super(key: key);

  final FirebaseAuth auth;

  @override
  _EnterMpinState createState() => _EnterMpinState();
}

class _EnterMpinState extends State<EnterMpin> {
  late FirebaseAuth _auth;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: _scaffoldKey,
      child: Scaffold(
        body: Container(
          color: Colors.grey.shade800,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                child: Row(
                  children: [
                    Icon(Icons.chevron_left, color: Colors.white),
                    Text('Back', style: TextStyle(color: Colors.white))
                  ],
                ),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignInPage(auth: _auth)));
                },
              ),
              SizedBox(height: 10),
              Center(
                child: Text('Nominate your 6-digit PIN',
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
                      // onTap: () {
                      //   FocusScope.of(context).requestFocus(_pinFocusNode1);
                      // },
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
                          // String overValue = value.substring(1, 2);
                          // value = value.substring(0, 1);
                          // _pinController1.text = value;
                          // _pinController2.text = overValue;
                          // FocusScope.of(context).requestFocus(_pinFocusNode3);

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
                              _reEnter();
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
                          _reEnter();
                        } else {
                          value = value.substring(0, 1);
                          _pinController6.text = value;
                          FocusScope.of(context).unfocus();
                          _reEnter();
                        }
                        print('nom pin: ${_pinControllerFull.text}');
                      },
                    ),
                  ),
                  Spacer(),
                ],
              ),
              // SizedBox(height: 30),
              // ElevatedButton(
              //   onPressed: () {
              //     _reEnter();
              //   },
              //   child: Text('Next'),
              //   style: ElevatedButton.styleFrom(
              //       minimumSize: Size(double.infinity, 40),
              //       textStyle: TextStyle(color: Colors.white)),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _reEnter() {
    if (_pinControllerFull.text.length == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ReenterMpin(auth: _auth, nominatedPin: _pinControllerFull.text),
        ),
      );
    }
  }
}
