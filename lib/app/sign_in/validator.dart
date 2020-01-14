abstract class StringValidator{
  bool isValid(String value);
}
class NonEmptyStrinValidator implements StringValidator{
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }


}
class EmailAndPasswordValidator{
  final StringValidator emailValidator=NonEmptyStrinValidator();
  final StringValidator passwordValidator=NonEmptyStrinValidator();
  final String invalidEmailErrorText='Email can\'t be empty';
  final String invalidPasswordErrorText='Password can\'t be empty';
}