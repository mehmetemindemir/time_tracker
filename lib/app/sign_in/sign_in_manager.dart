import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/services/auth.dart';

 class SignInManager{
   SignInManager({@required this.auth,this.isLoading});
   final AuthBase auth;
   final ValueNotifier<bool> isLoading;
   Future<User> _signIn(Future<User> Function() signInMethod ) async{
     try{
       isLoading.value=true;
       return await signInMethod();
     }catch(e){
       isLoading.value=false;
       rethrow;
     }
    }
    Future<User> signInWithAnonymously() async => _signIn(auth.signInWithAnonymously);
    Future<User> signWithGoogle() async => _signIn(auth.signWithGoogle);
 }