
import 'package:firebase_database/firebase_database.dart';


class Heroes
{
  String date,description,image,name,time,born,died;
  String id;

  Heroes(this.id,this.born,this.died,this.name,this.image,this.description,this.date,this.time );


//String born,String died,String name,String image,String description

  Heroes.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    born = snapshot.value['born'];
    died = snapshot.value['died'];
    name = snapshot.value['name'];
    image = snapshot.value['image'];
    description = snapshot.value['description'];
    date = snapshot.value['date'];
    time = snapshot.value['time'];
  }
}