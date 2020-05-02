import 'package:firebase_database/firebase_database.dart';

class Draft {
  String key;
  String subject;
  String dueDate;
  bool completed;
  String userId;

  Draft(this.subject, this.userId, this.completed,this.dueDate);

  Draft.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        userId = snapshot.value["userId"],
        subject = snapshot.value["subject"],
        completed = snapshot.value["completed"],
        dueDate = snapshot.value['dueDate'];

  toJson() {
    return {
      "userId": userId,
      "subject": subject,
      "completed": completed,
      "dueDate":dueDate,
    };
  }
}