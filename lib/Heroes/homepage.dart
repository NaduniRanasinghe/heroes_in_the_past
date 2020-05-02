import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stories_of_heroes/Drafts/draft.dart';
import 'package:stories_of_heroes/Authentication/authentication.dart';

import 'uploadhero.dart';
import 'package:stories_of_heroes/Heroes/Heroes.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';


class Home extends StatefulWidget
{

  Home
  ({
    this.auth,
    this.onSignedOut,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}
class _HomeState extends State<Home>
{
  List<Heroes> herolist = [];

  DatabaseReference heroRef = FirebaseDatabase.instance.reference().child("Heroes");
  void initState()
  {
    super.initState();

    heroRef.once().then((DataSnapshot snap)
    {

      String key = snap.key;
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      herolist.clear();
      for (var Ikey in KEYS)
      {
        Heroes heroes = new Heroes
      (
            DATA[Ikey][key],
            DATA[Ikey]['born'],
            DATA[Ikey]['died'],
            DATA[Ikey]['name'],
            DATA[Ikey]['image'],
            DATA[Ikey]['description'],
            DATA[Ikey]['date'],
            DATA[Ikey]['time'],
      );
        herolist.add(heroes);
      }
        setState(() {
          print('Length: $herolist.length');
        });
    });
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }



  void goToHomePage()
  {
    Navigator.push
      (
        context,
        MaterialPageRoute(builder: (context)
        {
          return Home();
        }
        )
    );
  }
//  deleteDraft(String draftId, int index) {
//    heroRef.child("Heroes").child(draftId).remove().then((_) {
//      print("Delete $draftId successful");
//      setState(() {
//        herolist.removeAt(index);
//      });
//    });
//  }

  void deleteHero(String id, int index) async {
    await heroRef.child(id).remove().then((_) {
      print('Transaction  committed.');

    });
  }
  deleteDraft(String draftId, int index) {
    FirebaseDatabase.instance.reference().child("Heroes").child(draftId).remove().then((_) {
      print("Delete $draftId successful");

    });
  }

  void _logoutUser()async
  {
      try
      {
        await widget.auth.logout();
        widget.onSignedOut();
      }
      catch(e)
       {
         print(e.toString());
       }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold
      (
      appBar: AppBar
        (
        title: Text("Home"),
      ),
      body: Container
        (
          child: herolist.length == 0? Text("No Heroes Updated") : ListView.builder
            (
            itemCount: herolist.length,
            itemBuilder: (_, index)
            {
              // ignore: argument_type_not_assignable
              return herosUI(index,herolist[index].id,herolist[index].born,herolist[index].died,
                  herolist[index].name,herolist[index].image,herolist[index].description);


            },
          ),
      ),

      bottomNavigationBar: BottomAppBar
        (
        color: Colors.orange,
        child: Container
          (
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>
            [
              IconButton
                (
                icon: Icon(Icons.person_outline),
                iconSize: 30,
                color: Colors.white,
                onPressed: _logoutUser,
              ),
              IconButton
                (
                icon: Icon(Icons.playlist_add),
                iconSize: 30,
                color: Colors.white,
                onPressed: (){
                  Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) {
                        return DraftPage();
                      })
                  );
                },
              ),
              IconButton
                (
                icon: Icon(Icons.add_photo_alternate),
                iconSize: 30,
                color: Colors.white,
                onPressed: () {
                  Navigator.push
                    (
                      context,
                      MaterialPageRoute(builder: (context) {
                        return HeroUpload();
                      })
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
    Widget herosUI(int ind,String index,String born,String died,String name,String image,String description)
    {


     // var parsedDate = DateTime.parse(died);
     // String convertedDate = new DateFormat("yyyy-MM-dd").format(parsedDate);
     // String died1 = convertDateTimeDisplay(died);
      return Dismissible(
        key: Key(index),
        background: Container(color: Colors.redAccent),

          onDismissed: (direction)  {
            //print(index);
            deleteDraft(index,ind);

            setState(() {
              herolist.removeAt(ind);
            });
          },
      child:new Card
        (
        elevation: 10.0,
        margin:EdgeInsets.all(15.0),


        child: new Container
          (
          padding: EdgeInsets.all(14.0) ,

          child: Column
            (
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>
            [
             Row
               (
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>
               [
                 Text
                   (
                   "Born : $born",
                   style: Theme.of(context).textTheme.subtitle,
                   textAlign: TextAlign.center,

                 ),

                 Text
                   (

                   "Died : $died",
                   style: Theme.of(context).textTheme.subtitle,
                   textAlign: TextAlign.center,

                 ),
               ],
             ),
              SizedBox(height:10.0 ,),
             Row
               (
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>
               [
                 Text
                   (
                   name,
                   style: Theme.of(context).textTheme.title,
                   textAlign: TextAlign.center,
                 ),
               ],
             ),
             SizedBox(height:5.0 ,),
              Image.network(image,fit:BoxFit.cover),
              SizedBox(height: 10.0,),
             Text
               (
               description,
               style: Theme.of(context).textTheme.subhead,
               textAlign: TextAlign.center,
             ),
             SizedBox(height: 5.0,),
            ],
          ) ,
          ),

        ),
      );
    }
}