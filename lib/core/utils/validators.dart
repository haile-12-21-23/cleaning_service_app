class AppValidators {
  static String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }

    /// REMOVE SPACES
    final phone = value.replaceAll(" ", "");

    /// ONLY DIGITS + OPTIONAL +
    final regex = RegExp(
      r'^\+?[0-9]{9,13}$',
    ); // Consider only Ethiopian phone number length

    if (!regex.hasMatch(phone)) {
      return "Enter valid phone number.";
    }

    return null;
  }
}
