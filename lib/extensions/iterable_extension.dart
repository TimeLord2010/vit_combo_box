extension IterableExtension<T> on Iterable<T> {
  /// Creates a new list from the iterable by interspersing a given [separator] between each element.
  /// If the iterable contains less than two elements, the original iterable is returned as a list.
  ///
  /// Example:
  /// ```dart
  /// final letters = ['a', 'b', 'c'];
  /// final spacedLetters = letters.separatedBy('-');
  /// print(spacedLetters); // ['a', '-', 'b', '-', 'c']
  /// ```
  List<T> separatedBy(T separator) {
    if (length < 2) return toList();
    return [first, separator, ...skip(1).separatedBy(separator)];
  }
}
