import 'package:bills/models/bills.dart';
import 'package:bills/pages/new_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'components/bottom_navigation.dart';

class ListViewPage extends StatefulWidget {
  ListViewPage(
      {required this.title, required this.quantification, required this.color});

  final String title;
  final String quantification;
  final Color color;

  @override
  _ListViewPage createState() => _ListViewPage();
}

class _ListViewPage extends State<ListViewPage> {
  late FToast fToast = FToast();

  Bills _bill = Bills();

  List<dynamic> _selectList = [];
  Stream<QuerySnapshot>? _listStream;
  String _quantification = '';
  String _collectionName = '';

  bool _isExpanded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fToast.init(context);
    _getPayers();
    setState(() {
      _collectionName = widget.title.toLowerCase();
      _quantification = widget
          .quantification; //_collectionName == 'electricity' ? 'kwh' : 'cu.m';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: widget.color,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _getlist,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildBody(),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      floatingActionButton: CustomFloatingActionButton(
          title: 'Add ${widget.title}',
          icon: Icons.add,
          color: widget.color,
          onTap: () {
            _showDataManager(_bill);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        physics: BouncingScrollPhysics(),
        child: StreamBuilder<QuerySnapshot>(
          stream: _listStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return !snapshot.hasData
                ? Center(child: Text('No ${widget.title} Yet.'))
                : Card(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Bills _bill = Bills.fromJson(
                              document.data() as Map<String, dynamic>);
                          _bill.id = document.id;
                          _bill.desciption = _bill.desciption ?? widget.title;
                          String _formattedBillDate = DateFormat('MMM dd, yyyy')
                              .format(_bill.billdate!);
                          String _lastModified =
                              DateFormat('MMM dd, yyyy hh:mm aaa')
                                  .format(_bill.modifiedOn ?? _bill.createdOn);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                //isThreeLine: true,
                                title: Text(_formattedBillDate),
                                //subtitle: Text('Created On: ${DateTime.fromMillisecondsSinceEpoch(data['created_on']).format()}'),
                                subtitle: Text(
                                    "${_setSelectedPayersDisplay(_bill.payerIds ?? [])}${_bill.desciption!.isNotEmpty ? " | ${_bill.desciption}" : ""}"),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'P ${_bill.amount}',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 25, color: widget.color),
                                    ),
                                    Text(
                                      '${_bill.quantification} $_quantification',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w200),
                                    ),
                                    Text(
                                      '$_lastModified',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // setState(() {
                                  //   _isExpanded = !_isExpanded;
                                  // });
                                  _showDataManager(_bill);
                                },
                              ),
                              Divider()
                            ],
                          );
                        },
                      ).toList(),
                    ),
                  );
          },
        ),
      ),
    );
  }

  _showDataManager(data) async {
    if ((await showAddRecord(
            context, data, _quantification, widget.title, widget.color)) ??
        false) _getlist();
  }

  Future<void> _getlist() async {
    _showProgressUi(true, "");

    try {
      var collection = FirebaseFirestore.instance.collection(_collectionName);
      var stream;

      collection.get().then((snapshots) {
        if (snapshots.docs.length > 0) {
          stream =
              collection.orderBy('bill_date', descending: true).snapshots();
        }
      }).whenComplete(() {
        setState(() {
          _listStream = stream;
        });
        _showProgressUi(false, "");
      });
    } on FirebaseAuthException catch (e) {
      _showProgressUi(false, "${e.message}.");
    } catch (e) {
      _showProgressUi(false, "$e.");
    }
  }

  String _setSelectedPayersDisplay(List<dynamic> _selectedList) {
    if (_selectedList.length >= 1) {
      int left = _selectedList.length - 1;
      String others = _selectedList.length > 1
          ? ' and $left other${left > 1 ? 's' : ''}'
          : '';
      return '${_getPayerName(_selectedList[0])}$others';
    } else if (_selectedList.length == 1) {
      return _getPayerName(_selectedList[0]);
    } else {
      return 'Select a Payer';
    }
  }

  Future<void> _getPayers() async {
    _showProgressUi(true, "");

    try {
      List<dynamic> users = [];
      CollectionReference _collection =
          FirebaseFirestore.instance.collection("users");
      _collection.get().then((querySnapshot) {
        querySnapshot.docs.forEach((document) {
          users.add([document.id, document.get('display_name')]);
        });
      }).whenComplete(() {
        setState(() {
          _selectList.addAll(users);
        });
        _showProgressUi(false, "");
        _getlist();
      });
    } on FirebaseAuthException catch (e) {
      _showProgressUi(false, "${e.message}.");
    } catch (e) {
      _showProgressUi(false, "$e.");
    }
  }

  String _getPayerName(String? id) {
    String payer = '';
    for (var p in _selectList) {
      if (p[0] == id) {
        payer = p[1] ?? '';
        break;
      }
    }
    return payer;
  }

  _showProgressUi(bool isLoading, String msg) {
    if (msg.length > 0) {
      Fluttertoast.showToast(msg: msg);
    }
    setState(() => _isLoading = isLoading);
  }
}
