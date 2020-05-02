import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:stories_of_heroes/Heroes/homepage.dart';
import 'package:stories_of_heroes/Other/constant.dart';


class HeroUpload extends StatefulWidget
{


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HeroUpload();
  }

}

class _HeroUpload extends State<HeroUpload>
{
  File sampleImage;
  String name,description, died,born;
  String url;
  final format = DateFormat("yyyy-MM-dd");
  var formatDate1 = new DateFormat('MMM d, yyyy');
  final formKey = new GlobalKey<FormState>();



  Future getImage() async
  {
    var tempImg = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImg;
    });
  }

bool validate()
{
  final form = formKey.currentState;
  if(form.validate())
    {
      form.save();
      return true;
    }
    else
      {
        return false;
      }

}

void uploadHeroImage() async

{
  if(validate()){
    final StorageReference postHeroRef = FirebaseStorage.instance.ref().child("Post Heroes");
    var timeKey = DateTime.now();
    final StorageUploadTask uploadTask = postHeroRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

    var HeroUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = HeroUrl.toString();

    print("Hero Url = " + url);
    
    goToHomePage();

    UploadToDatabase(url);
    }
}

void UploadToDatabase(url)
{
  var dbTimeKey = DateTime.now();
  var formatDate = new DateFormat('MMM d, yyyy');
  var formatTime = new DateFormat('EEEE , hh:mm aaa');

  String date = formatDate.format(dbTimeKey);
  String time = formatTime.format(dbTimeKey);
 // String died1 = formatDate.format(died);

  DatabaseReference dbRef = FirebaseDatabase.instance.reference();
  
  var data = 
  {
    "image":url,
    "name" :name,
    "description":description,
    "date":date,
    "time":time,
    "died":died,
    "born":born,
  };
  
  dbRef.child("Heroes").push().set(data);

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



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold
      (
        resizeToAvoidBottomPadding: false,
        appBar: AppBar
        (
        title: Text("Upload Hero"),
        centerTitle: true,
      ),

      body:
        Center(
          child: sampleImage == null? Text("Choose an Image"):enableUpload(),
        ),



      floatingActionButton: FloatingActionButton
        (
          onPressed: getImage,
          tooltip: "Add Image",

        child: Icon(Icons.camera_alt),
      ),
    );
  }


  Widget enableUpload()
  {
    return Container
      (
       child: Form
         (
         key: formKey,

         child: Column
           (
           children: <Widget>
           [
             Image.file(sampleImage, height: 250.0, width: 250.0,),


            // SizedBox(height: 5.0,),
             TextFormField
               (
               decoration: InputDecoration(labelText: "Name "),

               validator: (val)
               {
                 return val.isEmpty? 'Name is required':null;
               },
               onSaved: (val)
               {
                 return name = val;
               },
             ),
             SizedBox(height: 10.0,),

             TextFormField
               (
               decoration: InputDecoration(labelText: "Description "),

               validator: (val)
               {
                 return val.isEmpty? 'Description is required':null;
               },
               onSaved: (val)
               {
                 return description = val;
               },
             ),
             SizedBox(height: 5.0,),
             DateTimeField(
               decoration: textInputDeco.copyWith(hintText: 'Born'),
               format: format,
               onChanged: (val) {
                 setState(() => born = formatDate1.format(val));
               },
               onShowPicker: (context, currentValue) {
                 return showDatePicker(
                     context: context,
                     firstDate: DateTime(1900),
                     initialDate: currentValue ?? DateTime.now(),
                     lastDate: DateTime(2100));
               },
             ),


//             TextFormField
//               (
//               decoration: InputDecoration(labelText: "Born "),
//
//               validator: (val)
//               {
//                 return val.isEmpty? 'Year is required':null;
//               },
//               onSaved: (val)
//               {
//                 return born = val;
//               },
//             ),
             SizedBox(height: 5.0,),
             DateTimeField(
               decoration: textInputDeco.copyWith(hintText: 'Died'),
               format: format,
               onChanged: (val) {
                 setState(() => died = formatDate1.format(val));
               },
               onShowPicker: (context, currentValue) {
                 return showDatePicker(
                     context: context,
                     firstDate: DateTime(1900),
                     initialDate: currentValue ?? DateTime.now(),
                     lastDate: DateTime(2100));
               },
             ),

//             TextFormField
//               (
//               decoration: InputDecoration(labelText: "Died "),
//
//               validator: (val)
//               {
//                 return val.isEmpty? 'Year is required':null;
//               },
//               onSaved: (val)
//               {
//                 return died = val;
//               },
//             ),
             SizedBox(height: 5.0,),

             RaisedButton
               (
               elevation: 10.0,
               child: Text("ADD"),
               textColor: Colors.white,
               color:Colors.deepOrangeAccent,


               onPressed: uploadHeroImage,
             )

           ],
         ),


       ) ,
    );
  }

}