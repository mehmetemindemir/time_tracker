import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widget/platfrom_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';

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
    final database=Provider.of<Database>(context);
    await database.createJob({
      'name':'Deneme1',
      'ratePerHour':10
    });
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:()=> _createJob(context),
      ),
    );
  }


}
