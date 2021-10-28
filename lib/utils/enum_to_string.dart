/// Convert [enum] object to string
///
/// Pass in the not nullable [enum] object
/// and return the part after the dot.
///
/// By default this will convert [enumItem] to string
/// [withUnderscores] so `TestEnum.valueOne` will become `value_one`.
///
/// If [withUnderscores] is `false` this will leave the result of
/// `TestEnum.valueOne` equal to `valueOne`, as well as
/// `TestEnum.value_one` equal to `value_one`.
///
/// ```dart
/// enum TestEnum { valueOneAndTwo }
/// final eNum = enumToString(TestEnum.valueOneAndTwo);
/// eNum == 'value_one_and_two'; // true
///
/// final eNum = enumToString(TestEnum.valueOneAndTwo, camelCase = true);
/// eNum == 'valueOneAndTwo'; // true
/// ```
String enumToString<T extends Object>(
  T enumItem, {
  bool withUnderscores = true,
}) {
  final splitEnum = enumItem.toString().split('.');
  final enumType = enumItem.runtimeType.toString();
  assert(
    splitEnum.length == 2 && splitEnum.first == enumType,
    '$enumItem of type $enumType is not a valid enum item',
  );
  return withUnderscores ? splitEnum.last.withUnderscores() : splitEnum.last;
}

/// Given a string, find and return its matching [enum] value
///
/// This will try to match both strings in
/// camelCase and with underscores.
///
/// This is also case sensitive.
///
/// ```dart
/// enum TestEnum { valueOne, valueTwo }
/// final eNum = enumFromString(TestEnum.values, 'valueOne');
/// eNum == TestEnum.valueOne; // true
/// ```
T enumFromString<T extends Object>(Iterable<T> enumValues, String value) {
  return enumValues.singleWhere((enumItem) {
    final eNum = enumToString(enumItem, withUnderscores: false);
    return eNum == value || eNum.withUnderscores() == value;
  });
}

/// Convert [enum] to the list of strings
///
/// Pass in the [enum] values to the first argument,
/// for example `TestEnum.values`
///
/// The [withUnderscores] parameter acts accordingly to
/// [enumToString] implementation.
///
/// ```dart
/// enum TestEnum { valueOne, valueTwo }
/// final enumList = enumToList(TestEnum.values);
/// enumList == ['value_one', 'value_two']; // true
///
/// final enumList = enumToList(TestEnum.values, camelCase: true);
/// enumList == ['valueOne', 'valueTwo']; // true
/// ```
List<String> enumToList<T extends Object>(
  Iterable<T> enumValues, {
  bool withUnderscores = true,
}) {
  return enumValues
      .map((t) => enumToString(t, withUnderscores: withUnderscores))
      .toList();
}

/// Get a list of [enum] values from a list of strings
///
/// If some value from the [enum] object is not
/// in the [stringValues], it won't be returned.
///
/// If some value appends more than once,
/// it will be returned as many times as
/// it appends in [stringValues].
///
/// ```dart
/// enum TestEnum { valueOne, valueTwo }
///
/// final enumList = enumFromList(
///   TestEnum.values,
///   ['valueOne', 'value2'],
/// );
/// enumList == [TestEnum.valueOne]; // true
///
/// final enumList = enumFromList(
///   TestEnum.values,
///   ['value_two', 'valueTwo'],
/// );
/// enumList == [TestEnum.valueTwo, TestEnum.valueTwo]; // true
/// ```
List<T> enumFromList<T extends Object>(
  Iterable<T> enumValues,
  Iterable<String> stringValues,
) {
  return stringValues.map((item) => enumFromString(enumValues, item)).toList();
}

/// Extension on [String] for convertation
extension _ToStringWithUnderscores on String {
  RegExp get _capitalLettersRegex => RegExp('[A-Z]+');

  /// Convert initial camelCase string into string
  /// with underscores (`_`)
  ///
  /// ```dart
  /// final str = 'oneAndTwo'.withUnderscores();
  /// str == 'one_and_two'; // true
  /// ```
  String withUnderscores() {
    var newItem = this;
    for (final capitalLetter in _capitalLettersRegex.allMatches(this)) {
      final letter = capitalLetter.group(0)!;
      newItem = newItem.replaceFirst(letter, '_${letter.toLowerCase()}');
    }
    return newItem;
  }
}
