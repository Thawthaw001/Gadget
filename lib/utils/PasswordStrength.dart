String evaluatePasswordStrength(String password) {
  if (password.isEmpty) {
    return '';
  }
  int strength = 0;
  if (password.length >= 8) strength++;
  if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
  if (RegExp(r'[0-9]').hasMatch(password)) strength++;

  if (strength == 0) {
    return 'Weak';
  } else if (strength == 1) {
    return 'Weak';
  } else if (strength == 2) {
    return 'Medium';
  } else {
    return 'Strong';
  }
}
