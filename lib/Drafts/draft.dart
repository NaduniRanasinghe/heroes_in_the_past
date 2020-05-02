import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:stories_of_heroes/Heroes/uploadhero.dart';
import 'package:stories_of_heroes/Authentication/authenticate.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stories_of_heroes/Other/constant.dart';
import 'draftModel.dart';
import 'dart:async';

class DraftPage extends StatefulWidget {
  DraftPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  List<Draft> _draftList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onDraftCreateSubscription;
  StreamSubscription<Event> _onDraftChangedSubscription;

  final format = DateFormat("yyyy-MM-dd");
  var formatDate1 = new DateFormat('MMM d, yyyy');

  String dueDate;

  Query _draftQuery;

  //bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    //_checkEmailVerification();

    _draftList = new List();
    _draftQuery = _database
        .reference()
        .child("draft")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onDraftCreateSubscription = _draftQuery.onChildAdded.listen(onEntryAdded);
    _onDraftChangedSubscription =
        _draftQuery.onChildChanged.listen(onEntryChanged);
  }




  @override
  void dispose() {
    _onDraftCreateSubscription.cancel();
    _onDraftChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _draftList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _draftList[_draftList.indexOf(oldEntry)] =
          Draft.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _draftList.add(Draft.fromSnapshot(event.snapshot));
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  addNewDraft(String draftItem,String dueDate) {
    if (draftItem.length > 0) {
      Draft draft = new Draft(draftItem.toString(), widget.userId, false,dueDate.toString());
      _database.reference().child("draft").push().set(draft.toJson());
    }
  }

  updateDraft(Draft draft) {
    draft.completed = !draft.completed;
    if (draft != null) {
      _database.reference().child("draft").child(draft.key).set(draft.toJson());
    }
  }

  deleteDraft(String draftId, int index) {
    _database.reference().child("draft").child(draftId).remove().then((_) {
      print("Delete $draftId successful");
      setState(() {
        _draftList.removeAt(index);
      });
    });
  }

  showAddDraftDialog(BuildContext context) async {
    _textEditingController.clear();
    //dueDate.clear();

    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: Column(
                    children: <Widget>
                    [
                      new TextField(
                        controller: _textEditingController,
                        autofocus: true,
                        decoration: new InputDecoration(
                          labelText: 'Hero Name',
                        ),
                      ),
                      new DateTimeField(
                        decoration: textInputDeco.copyWith(hintText: 'Deadline'),
                        format: format,
                        onChanged: (val) {
                          setState(() => dueDate = formatDate1.format(val));
                        },
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                      ),


                    ],
                  ),

                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Create'),
                  onPressed: () {
                    addNewDraft(_textEditingController.text.toString(),dueDate);
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Widget showDraftList() {
    if (_draftList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _draftList.length,
          itemBuilder: (BuildContext context, int index) {
            String draftId = _draftList[index].key;
            String subject = _draftList[index].subject;
            String dueDate = _draftList[index].dueDate;
            bool completed = _draftList[index].completed;
            //String userId = _draftList[index].userId;

            return Dismissible(
              key: Key(draftId),
              background: Container(color: Colors.redAccent),
              onDismissed: (direction) async {
                deleteDraft(draftId, index);
              },

              child: ListTile(
                title: Text(
                  subject,
                  style: TextStyle(fontSize: 20.0),
                ),
                subtitle: Text(
                  dueDate,
                  style: TextStyle(fontSize: 20.0),
                ),
                trailing: IconButton(
                    icon: (completed)
                        ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 30.0,
                    )
                        : Icon(Icons.check_circle_outline, color: Colors.grey, size: 30.0),
                    onPressed: () {
                      updateDraft(_draftList[index]);
                    }),
              ),
            );
          });
    } else {
      return Center(
          child: Text(
            "Your draft list is empty",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Draft Heroes'),
          actions: <Widget>[

          ],
        ),
        body:




        showDraftList(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddDraftDialog(context);
        },
        tooltip: 'Create',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar
        (
        color: Colors.deepOrange,
        child: Container
          (
          margin: EdgeInsets.only(left: 10.0, right: 10.0),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,

            children: <Widget>
            [




            ],
          ),
        ),
      ),


    );
  }
}
