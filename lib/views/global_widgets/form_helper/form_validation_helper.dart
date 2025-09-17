class FormValidationHelper {

  String? noValidator() {
    return null;
  }

  String? emptyValidator(String value, String errorMessage) {
    if (value.isEmpty) {
      return errorMessage;
    } else {
      return null;
    }
  }

  String? passwordValidator(String value) {
    const String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Enter a valid Password.';
    } else {
      return null;
    }
  }
}
