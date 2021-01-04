/// This class represents a value-validated object.
///
/// Each value-validated object has to:
/// * Provide one (or more) meaningful failure implementation,
/// * Provide the Validator implementation,
/// * extend this class.
abstract class ValueValidated<T> {
  final T _value;
  final Validator<T> _validator;

  Failure _failure;
  T _validatedValue;

  ValueValidated(this._value, this._validator);

  bool get isValid {
    if (_failure == null) {
      _processValidator();
      return isValid;
    } else if (_failure is NoFailure) {
      return true;
    } else { // Failure case
      return false;
    }
  }

  bool get isFailed => !isValid;

  Failure get failure => _failure;
  T get value => _validatedValue;

  void _processValidator() {
    final validatorResult = _validator.getFailureOrNull();
    if (validatorResult == null) {
      _failure = NoFailure();
      _validatedValue = _value;
    } else {
      _failure = validatorResult;
      _validatedValue = null;
    }
  }
}

/// When extended, this class contains validation logic in the concrete
/// [getFailureOrNull] method.
///
/// It is intended to be used by a [ValueValidated] object. To use it, extend it
/// by providing the getFailureOrNull method.
abstract class Validator<T> {
  final T _value;
  Validator(this._value);

  /// Method for validation logic. If it returns null, value is
  /// validated. Otherwise, it shall return a concrete implementation of
  /// Failure.
  Failure getFailureOrNull();
}

/// This class represents a failed value of a value validated object (a
/// [ValueValidated] class). To use it, implement it with a meaningful
/// class name.
abstract class Failure {}

class NoFailure extends Failure {}