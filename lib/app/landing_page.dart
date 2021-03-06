import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/sign_in_page.dart';
import 'package:time_tracker/app/home/jobs_page.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';
class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth=Provider.of<AuthBase>(context);
    return     StreamBuilder(
      stream: auth.onAurhStateChanged,
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.active){
          User user=snapshot.data;
          if(null==user){
            return SingInPage.create(context);
          }
          return Provider<Database>(
            builder: (_)=>FirestoreDatabase(uid:user.uid),
              child: JobsPage());
        }else{
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

