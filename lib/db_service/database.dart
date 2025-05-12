

import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {
  Future addPersonalTask(Map<String,dynamic> userPersonalMap,String id) async{
    return await FirebaseFirestore.instance.
    collection('personal').
    doc(id).
    set(userPersonalMap);
  }
  Future addCollegeTask(Map<String,dynamic> userCollegeMap,String id) async{
    return await FirebaseFirestore.instance.
    collection('college').
    doc(id).
    set(userCollegeMap);
  }
  Future addOfficeTask(Map<String,dynamic> userOfficeMap,String id) async{
    return await FirebaseFirestore.instance.
    collection('office').
    doc(id).
    set(userOfficeMap);
  }

  Future<Stream<QuerySnapshot>>getTask(String task)async{
    return await FirebaseFirestore.instance.collection(task).snapshots();
  }

  tickMethod(String id , String task)async{
    return await FirebaseFirestore.instance.collection(task).doc(id).update({"Yes": true});
  }
  removeMethod(String id , String task)async{
    return await FirebaseFirestore.instance.collection(task).doc(id).delete();
  }

}
