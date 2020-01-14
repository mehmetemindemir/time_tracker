import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_bloc.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/common_widget/fomr_submit_button.dart';
import 'package:time_tracker/common_widget/platform_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget  {
  EmailSignInFormChangeNotifier({@required this.model});
  final EmailSignInChangeModel model;
  static Widget create(BuildContext context){
    final AuthBase auth=Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      builder: (context)=>EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context,model,_)=>EmailSignInFormChangeNotifier(model: model,),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() => _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState extends State<EmailSignInFormChangeNotifier> {

  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passworController=TextEditingController();
  final FocusNode _emailFocusNode=FocusNode();
  final FocusNode _passwordFocus=FocusNode();

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
     await widget.model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch(e){
      PlatformExceptionAlertDialog(
        title: 'Sign in Failed',
        exception:e,
      ).show(context);
    }

  }
  void _emailEditingComplate(){
    final focusedField=widget.model.emailValidator.isValid(widget.model.email)?_passwordFocus:_emailFocusNode;
    FocusScope.of(context).requestFocus(focusedField);
  }
  void _toogleFormType(){
    widget.model.toggleFormType();
    _emailController.clear();
    _passworController.clear();
  }

  List<Widget> _buildChildren(){
  return [
        _buildTextEmailField(),
      SizedBox(height: 8.0,),
      _buildTextPasswordField(),
      SizedBox(height: 8.0,),
      FormSubmitButton(
        text: widget.model.primaryButtonText,
        onPressed:widget.model.canSubmit? _submit:null,
      ),
      SizedBox(height: 8.0,),
      FlatButton(
        child: Text(widget.model.secondaryButtonText),
        onPressed:!widget.model.isLoading ? _toogleFormType:null,
      )
    ];
  }

  TextField _buildTextPasswordField() {

    return TextField(
      decoration: InputDecoration(
          labelText: 'Password',
        errorText: widget.model.passwordErrorText,
        enabled: widget.model.isLoading==false,
      ),
      obscureText: true,
      onChanged: widget.model.updatePassword,
      controller: _passworController,
      focusNode: _passwordFocus,

      textInputAction: TextInputAction.done,
      onEditingComplete:_submit,
    );
  }

  TextField _buildTextEmailField() {
    return TextField(
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: widget.model.emailErrorText,
          enabled: widget.model.isLoading==false,
        ),
        focusNode: _emailFocusNode,
        controller: _emailController,
        onChanged: widget.model.updateEmail,
        autocorrect: false,
        onEditingComplete:()=> _emailEditingComplate(),
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

}
