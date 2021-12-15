// ignore_for_file: use_key_in_widget_constructors, unused_import, prefer_final_fields

import 'package:bills/models/bill.dart';
import 'package:bills/models/user_profile.dart';
import 'package:bills/pages/components/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bills/helpers/extensions/format_extension.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';

import 'package:bills/pages/components/modal_base.dart';

Future<bool?> showBillManagement(
    context, data, quantification, title, color, userid) async {
  return await showModalBottomSheet<bool?>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Management(data, quantification, title, color, userid);
    },
  );
}

class Management extends StatefulWidget {
  final String title;
  final Bill bill;
  final String quantification;
  final Color color;
  final String? selectedUserId;

  const Management(this.bill, this.quantification, this.title, this.color,
      this.selectedUserId);

  @override
  State<StatefulWidget> createState() {
    return _ManagementState();
  }
}

class _ManagementState extends State<Management> {
  final FirebaseFirestore _ffInstance = FirebaseFirestore.instance;
  final DateTime _firstdate = DateTime(DateTime.now().year - 2);
  final DateTime _lastdate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  final _ctrlBillDate = TextEditingController();
  final _ctrlDesciption = TextEditingController();
  final _ctrlAmount = TextEditingController();
  final _ctrlQuantif = TextEditingController();
  final _ctrlSelectedPayers = TextEditingController();

  Bill _bill = Bill();

  late String _selectedUserId;
  List<String?> _selectedList = [];
  List<dynamic> _selectList = [];
  bool _selectedAll = false;
  bool _isExpanded = false;

  String _quantification = '';
  int _billTypeId = 0;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getPayers();
    setState(() {
      _bill = widget.bill;
      _selectedList.addAll(_bill.payerIds ?? []);
      _billTypeId = int.parse(_bill.billType!.id!);
      //_bill.billTypeId = _billTypeId;
      _selectedUserId = widget.selectedUserId ?? "";
      _quantification = widget.quantification;
      _bill.billDate = _bill.billDate ?? DateTime.now();
      _ctrlBillDate.text = _bill.billDate!.format();
      _ctrlDesciption.text = _bill.description ?? "";
      _ctrlAmount.text = _bill.amount!.format();
      _ctrlQuantif.text = _bill.quantification.toString();
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //String titleLast = widget.title.substring(widget.title.length - 1, widget.title.length);
    //bool isLastS = widget.title.endsWith("s"); //titleLast == 's';
    String _title = widget.title.endsWith("s")
        ? widget.title.substring(0, widget.title.length - 1)
        : widget.title;

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : generateModalBody(
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          icon: Icon(Icons.calendar_today, color: widget.color),
                          labelText: 'Bill Date',
                          hintText: 'Bill Date'),
                      controller: _ctrlBillDate,
                      readOnly: true,
                      onTap: () {
                        _getDate();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "0") {
                          return 'Invalid date.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          icon: Icon(Icons.label, color: widget.color),
                          labelText: 'Description',
                          hintText: 'Description'),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      controller: _ctrlDesciption,
                      onChanged: (value) {
                        setState(() {
                          _bill.description = value;
                        });
                      },
                      onTap: () {
                        if ((_bill.description.isNullOrEmpty()) ||
                            _bill.description!.isEmpty ||
                            _bill.description == widget.title) {
                          _ctrlDesciption.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _ctrlDesciption.text.length);
                        }
                      },
                      // validator: (value) {
                      //   if (value == null || value.isEmpty || value == "0") {
                      //     return 'Must be geater than 0.';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          icon: Icon(Icons.attach_money_outlined,
                              color: widget.color),
                          labelText: 'Amount',
                          hintText: 'Amount'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: _ctrlAmount,
                      onChanged: (value) {
                        setState(() {
                          _bill.amount = num.parse(value);
                        });
                      },
                      onTap: () {
                        if (_bill.amount.toString() == "0" ||
                            _bill.amount.toString() == "") {
                          _ctrlAmount.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _ctrlAmount.text.length);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "0") {
                          return 'Must be geater than 0.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          icon: Icon(Icons.pin, color: widget.color),
                          labelText: _quantification,
                          hintText: _quantification),
                      keyboardType: TextInputType.number,
                      controller: _ctrlQuantif,
                      onChanged: (value) {
                        setState(() {
                          _bill.quantification = int.parse(value);
                        });
                      },
                      onTap: () {
                        if (_bill.quantification.toString() == "0" ||
                            _bill.quantification.toString() == "") {
                          _ctrlQuantif.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _ctrlQuantif.text.length);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "0") {
                          return 'Must be geater than 0.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    AnimatedContainer(
                      height: _isExpanded ? 600 : 50,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.fastOutSlowIn,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            showCursor: false,
                            readOnly: true,
                            controller: _ctrlSelectedPayers,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(5),
                              icon: Icon(Icons.person, color: widget.color),
                              suffixIcon: _isExpanded
                                  ? CustomAppBarButton(
                                      onTap: () => setState(() {
                                        _selectedList.clear();
                                        //_selectedList2.clear();
                                        if (!_selectedAll) {
                                          for (int b = 0;
                                              b < _selectList.length;
                                              b++) {
                                            _selectedList
                                                .addAll(_selectList[b]);
                                            //_selectedList2.add(_selectList)
                                          }
                                        }
                                        setState(() {
                                          _selectedAll = !_selectedAll;
                                        });
                                        _setSelectedPayersDisplay();
                                      }),
                                      icon: Icons.select_all,
                                      checkedColor: Colors.teal,
                                      uncheckedColor: Colors.white,
                                      isChecked: _selectedAll,
                                    )
                                  : const SizedBox(),
                              labelText: 'Select Payer(s)',
                              hintText: 'Select Payer(s)',
                            ),
                            onTap: () async {
                              setState(() {
                                if (_isExpanded) {
                                  _isExpanded = false;
                                  SystemChrome.setEnabledSystemUIMode(
                                      SystemUiMode.manual,
                                      overlays: SystemUiOverlay.values);
                                } else {
                                  _isExpanded = true;
                                  SystemChrome.setEnabledSystemUIMode(
                                      SystemUiMode.manual,
                                      overlays: [SystemUiOverlay.bottom]);
                                }
                              });
                            },
                            onChanged: (value) {},
                            validator: (value) {
                              if (_selectedList.isEmpty) {
                                return 'Must select at least 1';
                              }
                              return null;
                            },
                          ),
                          ..._isExpanded
                              ? <Widget>[
                                  const Divider(thickness: 1, height: 0),
                                  _payersSelectionWidget()
                                ]
                              : <Widget>[]
                        ],
                      ),
                    ),
                    //SizedBox(height: 10),
                    // ElevatedButton(
                    //   child: _isLoading
                    //       ? Center(child: CircularProgressIndicator())
                    //       : Text('Save'),
                    //   style: ElevatedButton.styleFrom(
                    //       minimumSize: Size(double.infinity, 50),
                    //       primary: widget.color,
                    //       textStyle: TextStyle(color: Colors.white)),
                    //   onPressed: !_isLoading ? _saveRecord : null,
                    // ),
                    // SizedBox(height: 10),
                    // ElevatedButton(
                    //   onPressed: _cancel,
                    //   child: Text('Cancel'),
                    //   style: ElevatedButton.styleFrom(
                    //       minimumSize: Size(double.infinity, 50),
                    //       primary: Colors.grey.shade800,
                    //       textStyle: TextStyle(color: widget.color)),
                    // ),
                  ],
                ),
              ),
            ),
            [],
            headWidget: Row(
              children: [
                TextButton(
                  child: const Icon(Icons.close, size: 30, color: Colors.grey),
                  onPressed: _cancel,
                ),
                const Spacer(),
                Text('${_bill.id != null ? 'Manage' : "Add"} $_title',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                const Spacer(),
                _bill.id != null
                    ? TextButton(
                        child: const Icon(Icons.delete,
                            size: 30, color: Colors.grey),
                        onPressed: !_isLoading ? _deleteRecord : null,
                      )
                    : const SizedBox(),
                TextButton(
                  child: Icon(Icons.done, size: 30, color: widget.color),
                  onPressed: !_isLoading ? _saveRecord : null,
                ),
              ],
            ),
            header: 'Add $_title');
  }

  _getDate() async {
    var date = await showDatePicker(
      context: context,
      initialDate: _bill.billDate!,
      firstDate: _firstdate,
      lastDate: _lastdate,
    );
    if (date != null) {
      setState(() {
        _bill.billDate = DateTime(date.year, date.month, date.day);
        _ctrlBillDate.text = _bill.billDate!.formatDate(dateOnly: true);
      });
    }
  }

  _saveRecord() async {
    _showProgressUi(true, "Saving");

    if (_formKey.currentState!.validate()) {
      setState(() {
        _bill.payerIds?.clear();
        _bill.payerIds?.addAll(_selectedList);
      });

      List<String> newPayers = [];
      _bill.payerIds?.forEach((element) {
        String? pbt = "${element}_$_billTypeId";
        newPayers.add(pbt);
      });
      setState(() {
        _bill.payersBillType = newPayers;
      });

      try {
        CollectionReference list = _ffInstance.collection("bills");
        if (_bill.id.isNullOrEmpty()) {
          var data = _bill.toJson();
          list.add(data).then((value) {
            setState(() {
              _isExpanded = false;
            });
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: SystemUiOverlay.values);
            _updateBillingDates();
            _showProgressUi(false, "");
            Navigator.pop(context);
          }).catchError((error) {
            _showProgressUi(false, "Failed to add bill: $error.");
          });
        } else {
          _bill.modifiedOn = DateTime.now();
          list.doc(_bill.id).update(_bill.toJson()).then((value) {
            setState(() {
              _isExpanded = false;
            });
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                overlays: SystemUiOverlay.values);
            Navigator.pop(context);
            _updateBillingDates();
            _showProgressUi(false, "Bill updated.");
          }).catchError((error) {
            _showProgressUi(false, "Failed to update bill: $error.");
          });
        }
      } on FirebaseAuthException catch (e) {
        _showProgressUi(false, "${e.message}.");
      } catch (e) {
        _showProgressUi(false, "$e.");
      }
    }
  }

  _deleteRecord() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text(
            'You are about to delete a record. This action is irreversible'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              _showProgressUi(true, "Deleting record...");
              try {
                String collection = widget.title.toLowerCase();

                _ffInstance
                    .collection(collection)
                    .doc(_bill.id)
                    .delete()
                    .then((_) {
                  _showProgressUi(false, "Record deleted");
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              } on FirebaseAuthException catch (e) {
                _showProgressUi(false, "${e.message}.");
              } catch (e) {
                _showProgressUi(false, "$e.");
              }
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  _updateBillingDates() {
    if (widget.title.toLowerCase() != 'payment') {
      try {
        CollectionReference collection = _ffInstance.collection("users");
        UserProfile userProfile = UserProfile();
        collection.get().then((snapshots) {
          for (var document in snapshots.docs) {
            if (_bill.payerIds?.contains(document.id) ?? false) {
              userProfile =
                  UserProfile.fromJson(document.data() as Map<String, dynamic>);
              userProfile.id = document.id;
              if (userProfile.billingDate == null) {
                collection.doc(userProfile.id).update({
                  'billing_date': _bill.billDate?.toIso8601String()
                }).whenComplete(() {});
              }
            }
          }
        }).whenComplete(() {
          _showProgressUi(false, "");
        });
      } on FirebaseAuthException catch (e) {
        _showProgressUi(false, "${e.message}.");
      } catch (e) {
        _showProgressUi(false, "$e.");
      }
    }
  }

  _cancel() {
    setState(() {
      _ctrlBillDate.clear();
      _ctrlAmount.clear();
      _selectedList.clear();
    });
    Navigator.of(context).pop(false);
  }

  Future<void> _getPayers() async {
    _showProgressUi(true, "");

    try {
      List<dynamic> users = [];
      CollectionReference _collection = _ffInstance.collection("users");
      _collection.get().then((snapshots) {
        for (var document in snapshots.docs) {
          //String pbt = "${document.id}_$_billType";
          users.add([document.id, document.get('name')]);
        }
      }).whenComplete(() {
        setState(() {
          _selectList.clear();
          _selectList.addAll(users);
        });
        _showProgressUi(false, "");
        _setSelectedPayersDisplay();
      });
    } on FirebaseAuthException catch (e) {
      _showProgressUi(false, "${e.message}.");
    } catch (e) {
      _showProgressUi(false, "$e.");
    }
  }

  Widget _payersSelectionWidget() {
    List<Widget> mList = <Widget>[];
    for (int b = 0; b < _selectList.length; b++) {
      String id = _selectList[b][0];
      String displayname = _selectList[b][1] ?? "No Name";
      mList.add(CheckboxListTile(
        selected: _selectedList.toString().contains(id),
        //selected: _selectedList.contains(id),
        //selected: _selectedList.contains((value) => value[0] == id),
        //selected: _selectedList.contains((value) => value.contains(id)),
        onChanged: (bool? value) {
          setState(() {
            if (value as bool) {
              _selectedList.add(id);
              //_selectedList.addAll({{"id": id, "name": displayname, "deleted": false}});
              //_selectedList.addAll({{"id": id, "deleted": false, "name": displayname}});
            } else {
              //_selectedList.removeWhere((value) => value.toString().contains(id));
              //_selectedList.remove((key, value) => key == id);
              _selectedList.remove(id);
              //_selectedList.remove((key, value) => key.containsKey(id));
              //_selectedList.removeWhere((key, value) => key == id);
            }
          });
          if (kDebugMode) {
            print(_selectedList);
          }
          _setSelectedPayersDisplay();
        },
        value: _selectedList.toString().contains(id),
        title: Text(displayname),
        controlAffinity: ListTileControlAffinity.leading,
      ));
    }
    return ListView(shrinkWrap: true, children: mList);
  }

  _setSelectedPayersDisplay() {
    setState(() {
      if (_selectedList.isNotEmpty) {
        int left = _selectedList.length - 1;
        String? payer = _getPayerName(_selectedUserId);
        String? others =
            left > 0 ? " and $left other${left > 1 ? 's' : ''}" : "";
        _ctrlSelectedPayers.text = "$payer$others";
      } else {
        _ctrlSelectedPayers.text = 'Select Payer(s)';
      }
      _selectedAll = _selectList.length == _selectedList.length;
    });
  }

  String? _getPayerName(String? id) {
    String ret = (_selectList.where((element) => element.first == id).last)
        .last
        .toString();
    return ret;
  }

  _showProgressUi(bool isLoading, String msg) {
    if (msg.isNotEmpty) {
      Fluttertoast.showToast(msg: msg);

      if (kDebugMode) {
        print("msg: $msg");
      }
    }
    setState(() => _isLoading = isLoading);
  }
}
