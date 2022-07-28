/// An exception thrown when accessing a field whose type is not of the expected
/// type.
class TypeMismatchException implements Exception {
  /// Create a new [TypeMismatchException] given the problematic [field], the
  /// [expected], and the [actual].
  TypeMismatchException({
    required this.field,
    required this.expected,
    required this.actual,
  });

  static const _prefix = 'Type mismatch';

  /// The problematic field.
  final Object field;

  /// Type that was expected.
  final Type expected;

  /// Type that was actually provided.
  final Type actual;

  @override
  String toString() {
    return '$_prefix ($field): Expected $expected but got $actual';
  }
}
