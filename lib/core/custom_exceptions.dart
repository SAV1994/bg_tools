class StepWizardException implements Exception {
  final String message;

  const StepWizardException(this.message);

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;

  const ValidationException(this.message);

  @override
  String toString() => message;
}
