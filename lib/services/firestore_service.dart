import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService{
  FirestoreService._();
  static final  instance=FirestoreService._();
  Stream<List<T>> collectionStream<T>({@required String path,@required T builder(Map<String,dynamic> data)}){
    final referance = Firestore.instance.collection(path);
    final snapshots = referance.snapshots();
    return snapshots.map((snapshot)=>snapshot.documents.map((snapshot)=>builder(snapshot.data)).toList());
  }
  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print('$path:$data');
    await reference.setData(data);
  }

}