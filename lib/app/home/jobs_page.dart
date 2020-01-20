import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widget/platform_exception_alert_dialog.dart';
import 'package:time_tracker/common_widget/platfrom_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';
import 'package:flutter/services.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    final auth=Provider.of<AuthBase>(context);
    try {
       await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void>  _createJob(BuildContext context) async{
    try {
      final database = Provider.of<Database>(context);
      await database.createJob(Job(name: 'Deneme3', ratePerHour: 12));


    } on PlatformException catch(e){
      PlatformExceptionAlertDialog(
        title: "Operation Failed",
        exception: e,
      ).show(context);
    }
  }
  Future<void> _confirmSignOut(BuildContext context) async{
   final didRequestSignOut= await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout',
      defualtActionText: 'Logout',
     cancelActionText: 'Cancel',
    ).show(context);
   if(didRequestSignOut){
     _signOut(context);
   }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Jobs Page"),
        actions: <Widget>[
          FlatButton(
            child: Text("Log Out",style: TextStyle(fontSize: 18.0,color: Colors.white),),
            onPressed:()=> _confirmSignOut(context),
          ),
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:()=> _createJob(context),
      ),
    );
  }

   Widget _buildContents(BuildContext context) {
    final database=Provider.of<Database>(context);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStram(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          final jobs=snapshot.data;
          final children=jobs.map((job)=>Text(job.name)).toList();
          return ListView(children: children);
        }
        if(snapshot.hasError){
          return Center(child: Text('Some error occurred'),);
        }
        return Center(child: CircularProgressIndicator(),);
      },
    );
  }


}
