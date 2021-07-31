import 'package:bills/pages/biometrics/biometrics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.auth}) : super(key: key);

  final FirebaseAuth auth;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    setState(() {
      _auth = widget.auth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.chevron_left),
        ),
        iconTheme: IconThemeData(color: Colors.grey.shade300),
        textTheme:
            TextTheme(headline6: TextStyle(color: Colors.white, fontSize: 25)),
        title: Text('Settings'),
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: Colors.grey.shade800,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Divider(),
            ListTile(
              leading: Icon(Icons.fingerprint),
              title: Text('Biometrics'),
              trailing: Icon(Icons.chevron_right, size: 20),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Biometrics(auth: _auth)),
                );
              },
            ),
            Divider(),
            // ListTile(
            //   leading: Icon(Icons.restore),
            //   title: Text('Backup & Restore'),
            //   trailing: Icon(Icons.chevron_right, size: 20),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => About()),
            //     );
            //   },
            // ),
            //Divider(),
          ],
        ),
      ),
    );
  }
}
