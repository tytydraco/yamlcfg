/// An exception thrown when accessing a field that does not exist, and no
/// fallback handler was provided.
class MissingFieldException implements Exception {
  /// Create a new [MissingFieldException] optionally specifying a [message] and
  /// the problematic [field].
  MissingFieldException({
    required this.field,
    this.message,
  });

  static const _prefix = 'Missing field';

  /// The problematic field.
  final Object field;

  /// Reason to provide to caller.
  final Object? message;

  @override
  String toString() {
    if (message != null) return '$_prefix ($field): $message';
    return _prefix;
  }
}
