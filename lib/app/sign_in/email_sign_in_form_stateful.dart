import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/app/sign_in/validator.dart';
import 'package:time_tracker/common_widget/fomr_submit_button.dart';
import 'package:time_tracker/common_widget/platform_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInFormStateful extends StatefulWidget with EmailAndPasswordValidator {

  @override
  _EmailSignInFormStatefulState createState() => _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {

  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passworController=TextEditingController();
  final FocusNode _emailFocusNode=FocusNode();
  final FocusNode _passwordFocus=FocusNode();
  String get _email=>_emailController.text;
  String get _password =>_passworController.text;
  EmailSignInFormType _formType=EmailSignInFormType.signIn;
  bool _submitted=false;
  bool _isLoading=false;
  @override
  void dispose(){
    _emailFocusNode.dispose();
    _passwordFocus.dispose();
    _passworController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  void _submit() async{
    setState(() {
      _submitted=true;
      _isLoading=true;
    });
    try{
      final auth=Provider.of<AuthBase>(context);
      if(EmailSignInFormType.signIn==_formType){
        await auth.signWithEmail(_email, _password);
      }else{
        await auth.creatWithEmail(_email, _password);
      }
      Navigator.of(context).pop();
    } on PlatformException catch(e){
      PlatformExceptionAlertDialog(
        title: 'Sign in Failed',
        exception:e,
      ).show(context);
    }finally{
      setState(() {
        _isLoading=false;
      });
    }

  }
  void _emailEditingComplate(){
    final focusedField=widget.emailValidator.isValid(_email)?_passwordFocus:_emailFocusNode;
    FocusScope.of(context).requestFocus(focusedField);
  }
  void _toogleFormType(){
    setState(() {
      _submitted=false;
      _formType=_formType==EmailSignInFormType.signIn?EmailSignInFormType.register:EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passworController.clear();
  }

  List<Widget> _buildChildren(){
    final primaryText=_formType==EmailSignInFormType.signIn ?'Sign In ': 'Create an Account';
    final secondaryText=_formType==EmailSignInFormType.signIn?'Need an account ? Register':' Have an account ? Sign In';
    bool submitEnabled=widget.emailValidator.isValid(_email) && widget.passwordValidator.isValid(_password)&& !_isLoading;
    return [
        _buildTextEmailField(),
      SizedBox(height: 8.0,),
      _buildTextPasswordField(),
      SizedBox(height: 8.0,),
      FormSubmitButton(
        text: primaryText,
        onPressed:submitEnabled? _submit:null,
      ),
      SizedBox(height: 8.0,),
      FlatButton(
        child: Text(secondaryText),
        onPressed:!_isLoading ? _toogleFormType:null,
      )
    ];
  }

  TextField _buildTextPasswordField() {
    bool showErrorText=_submitted && !widget.emailValidator.isValid(_password);
    return TextField(
      decoration: InputDecoration(
          labelText: 'Password',
        errorText: showErrorText?widget.invalidPasswordErrorText:null,
        enabled: _isLoading==false,
      ),
      obscureText: true,
      onChanged: (password)=>_updateState(),
      controller: _passworController,
      focusNode: _passwordFocus,

      textInputAction: TextInputAction.done,
      onEditingComplete:_submit,
    );
  }

  TextField _buildTextEmailField() {
    bool showErrorText=_submitted && !widget.emailValidator.isValid(_email);
    return TextField(
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: showErrorText?widget.invalidEmailErrorText:null,
          enabled: _isLoading==false,
        ),
        focusNode: _emailFocusNode,
        controller: _emailController,
        onChanged: (email)=>_updateState(),
        autocorrect: false,
        onEditingComplete: _emailEditingComplate,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

 void _updateState() {
    setState(() { });
 }
}
