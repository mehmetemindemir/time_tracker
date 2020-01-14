import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});

  final AuthBase auth;
  final StreamController<EmailSignInModel> _emailSignInController =
      StreamController<EmailSignInModel>();
  EmailSignInModel _model = EmailSignInModel();

  Stream<EmailSignInModel> get isEmailSignInStream =>
      _emailSignInController.stream;

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);
  void toggleFormType(){
    final formType=_model.formType==EmailSignInFormType.signIn?EmailSignInFormType.register:EmailSignInFormType.signIn;
    updateWith(email: '',password: '',formType: formType,isLoading: false,submitted: false);
  }
  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    _emailSignInController.add(_model);
  }

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);
    try {
      if (EmailSignInFormType.signIn == _model.formType) {
        await auth.signWithEmail(_model.email, _model.password);
      } else {
        await auth.creatWithEmail(_model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void dispose() {
    _emailSignInController.close();
  }
}
