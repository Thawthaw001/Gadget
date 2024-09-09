// class FormValidator {
//   static String? validateName(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Text field can not be empty!';
//     }
//     return null;
//   }

//   static bool isEmailValid(String email) {
//     return RegExp(
//             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//         .hasMatch(email);
//   }

//   static String? validatePassword(String? value) {
//     String pattern =
//         r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
//     RegExp regExp = RegExp(pattern);
//     return value!.isNotEmpty && !regExp.hasMatch(value)
//         ? 'Password is wrong'
//         : null;
//   }
// }
class FormValidator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Text field can not be empty!';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isEmailValid(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static bool isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(email);
  }

  static String? validatePassword(String? value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return value!.isNotEmpty && !regExp.hasMatch(value)
        ? 'Password is wrong'
        : null;
  }
}

