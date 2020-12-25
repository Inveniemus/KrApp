/// This class represents a value-validated object.
///
/// Each value-validated object has to:
/// * extend this class with proper Type T,
/// * Provide the validate() method,
/// * Provide meaningful failures.
abstract class ValueValidated<T> {
  T _value;
  Failure _failure;

  ValueValidated(this._value) {
    validate();
  }

  bool get isFailed => _failure != null;
  T get value => _value;

  void validate();
}

/// This class represents a failed value of a value validated object (a
/// [ValueValidated] concrete class). To use it, implement it with a meaningful
/// class name.
abstract class Failure {
  String _description;
  Failure(this._description);

  @override
  String toString() => _description;
}