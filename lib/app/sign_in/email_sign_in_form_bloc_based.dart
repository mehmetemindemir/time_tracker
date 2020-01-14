import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_bloc.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/common_widget/fomr_submit_button.dart';
import 'package:time_tracker/common_widget/platform_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInFormBlocBased extends StatefulWidget  {
  EmailSignInFormBlocBased({@required this.bloc});
  final EmailSignInBloc bloc;
  static Widget create(BuildContext context){
    final AuthBase auth=Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      builder: (context)=>EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context,bloc,_)=>EmailSignInFormBlocBased(bloc: bloc,),
      ),
      dispose: (context,bloc)=>bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() => _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {

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
  Future<void> _submit() async{

    try{
     await widget.bloc.submit();
      Navigator.of(context).pop();
    } on PlatformException catch(e){
      PlatformExceptionAlertDialog(
        title: 'Sign in Failed',
        exception:e,
      ).show(context);
    }

  }
  void _emailEditingComplate(EmailSignInModel model){
    final focusedField=model.emailValidator.isValid(_email)?_passwordFocus:_emailFocusNode;
    FocusScope.of(context).requestFocus(focusedField);
  }
  void _toogleFormType(){
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passworController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model){
  return [
        _buildTextEmailField(model),
      SizedBox(height: 8.0,),
      _buildTextPasswordField(model),
      SizedBox(height: 8.0,),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed:model.canSubmit? _submit:null,
      ),
      SizedBox(height: 8.0,),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed:!model.isLoading ? _toogleFormType:null,
      )
    ];
  }

  TextField _buildTextPasswordField(EmailSignInModel model) {

    return TextField(
      decoration: InputDecoration(
          labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading==false,
      ),
      obscureText: true,
      onChanged: widget.bloc.updatePassword,
      controller: _passworController,
      focusNode: _passwordFocus,

      textInputAction: TextInputAction.done,
      onEditingComplete:_submit,
    );
  }

  TextField _buildTextEmailField(EmailSignInModel model) {
    return TextField(
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: model.emailErrorText,
          enabled: model.isLoading==false,
        ),
        focusNode: _emailFocusNode,
        controller: _emailController,
        onChanged: widget.bloc.updateEmail,
        autocorrect: false,
        onEditingComplete:()=> _emailEditingComplate(model),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      );
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.isEmailSignInStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(snapshot.data),
          ),
        );
      }
    );
  }

}
