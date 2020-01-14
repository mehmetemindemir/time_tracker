import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
abstract class Database{
  Future<void> createJob(Map<String,dynamic> jsonData);
}
class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}):assert(null!=uid);
  final String uid;
  Future<void> createJob(Map<String,dynamic> jsonData) async {
    final path='users/$uid/jobs/job_abc';
    final documentReference=Firestore.instance.document(path);
    await documentReference.setData(jsonData);
  }

}