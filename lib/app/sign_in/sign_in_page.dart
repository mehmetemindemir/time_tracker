import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker/app/sign_in/sign_in_buttom.dart';
import 'package:time_tracker/app/sign_in/social_sign_in_buttom.dart';
import 'package:time_tracker/common_widget/platform_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

class SingInPage extends StatelessWidget {
  const SingInPage({Key key, @required this.manager,@required this.isLoading}) : super(key: key);
  final SignInManager manager;
  final bool isLoading;
  static Widget create(BuildContext context) {
    final auth=Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      builder: (_)=> ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_,isLoading,__)=> Provider<SignInManager>(
          builder: (_) => SignInManager(auth: auth,isLoading: isLoading),
          child: Consumer<SignInManager>(
              builder: (context, manager, _) => SingInPage(
                    manager: manager,isLoading: isLoading.value, )),
        ),
      ),
    );
  }

  void _showError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInWithAnonymously();
    } on PlatformException catch (e) {
      _showError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signWithGoogle();
    } on PlatformException catch (e) {
      _showError(context, e);
    }
  }

  void _signWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => EmailSignInPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker"),
        elevation: 2.0,
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50.0, child: _buildHeader()),
          SizedBox(
            height: 48.0,
          ),
          SocialSignInButtom(
            icon: "images/google-logo.png",
            text: "Sign In with Google",
            color: Colors.white,
            borderRadius: 4.0,
            textColor: Colors.black87,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
            height: 50.0,
          ),
          SizedBox(
            height: 8.0,
          ),
          SocialSignInButtom(
            icon: 'images/facebook-logo.png',
            text: "Sign In with Facebook",
            color: Color(0xFF334D92),
            borderRadius: 4.0,
            textColor: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
            height: 50.0,
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButtom(
            text: "Sign In with Email",
            color: Colors.teal[700],
            borderRadius: 4.0,
            textColor: Colors.white,
            onPressed: isLoading ? null : () => _signWithEmail(context),
            height: 50.0,
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            "OR",
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8.0,
          ),
          SignInButtom(
            text: "Go anonymous",
            color: Colors.lime[300],
            borderRadius: 4.0,
            textColor: Colors.black,
            onPressed: isLoading ? null : () => _signInAnonymously(context),
            height: 50.0,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      "Sign In",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }
}
