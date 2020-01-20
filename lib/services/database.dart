import 'package:flutter/cupertino.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStram();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(null != uid);
  final String uid;
  final _service=FirestoreService.instance;
  Future<void> createJob(Job job) async => _service.setData(path: APIPath.job(uid, 'job_abc'), data: job.toMap());
  Stream<List<Job>> jobsStram()=>_service.collectionStream(path: APIPath.jobs(uid), builder: (data)=>Job.fromMap(data));

}
