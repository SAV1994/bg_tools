class StepWizardException implements Exception {
  final String message;

  const StepWizardException(this.message);

  @override
  String toString() => message;
}
