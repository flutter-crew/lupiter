import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;

// ignore_for_file: avoid_print

const _preservedKeywords = [
  'few',
  'many',
  'one',
  'other',
  'two',
  'zero',
  'male',
  'female',
];

String _gFilePrefix = '''
// DO NOT EDIT. This is code generated with flutterCrew utils package. Sourced from package:easy_localization/generate.dart

// ignore_for_file: public_member_api_docs, prefer_single_quotes, lines_longer_than_80_chars

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

''';

String _keysFilePrefix = '''
// DO NOT EDIT. This is code generated with flutterCrew utils package. Sourced from package:easy_localization/generate.dart

// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

abstract class TR {
''';

Future<void> main(List<String> args) async {
  if (_isHelpCommand(args)) {
    _printHelperDisplay();
  } else {
    await handleLangFiles(_generateOption(args));
  }
}

bool _isHelpCommand(List<String> args) =>
    args.length == 1 && (args[0] == '--help' || args[0] == '-h');

void _printHelperDisplay() =>
    print(_generateArgParser(GenerateOptions()).usage);

GenerateOptions _generateOption(List<String> args) {
  final generateOptions = GenerateOptions();
  _generateArgParser(generateOptions).parse(args);
  return generateOptions;
}

ArgParser _generateArgParser(GenerateOptions generateOptions) {
  final parser = ArgParser()
    ..addOption(
      'source-dir',
      abbr: 'S',
      defaultsTo: 'resources/langs',
      callback: (x) => x is String ? generateOptions.sourceDir = x : null,
      help: 'Folder containing localization files',
    )
    ..addOption(
      'source-file',
      abbr: 's',
      callback: (x) => x is String ? generateOptions.sourceFile = x : null,
      help: 'File to use for localization',
    )
    ..addOption(
      'output-dir',
      abbr: 'O',
      defaultsTo: 'lib/generated',
      callback: (x) => x is String ? generateOptions.outputDir = x : null,
      help: 'Output folder stores for the generated file',
    )
    ..addOption(
      'output-file',
      abbr: 'o',
      defaultsTo: 'codegen_loader.g.dart',
      callback: (x) =>
          x is String ? generateOptions.outputFile = path.basename(x) : null,
      help: 'Output file name',
    )
    ..addOption(
      'format',
      abbr: 'f',
      defaultsTo: 'json',
      callback: (x) => x is String ? generateOptions.format = x : null,
      help: 'Support json or keys formats',
      allowed: ['json', 'keys'],
    );

  return parser;
}

class GenerateOptions {
  late String sourceDir;
  String? sourceFile;
  String? templateLocale;
  late String outputDir;
  String? outputFile;
  late String format;

  @override
  String toString() {
    return 'format: $format sourceDir: $sourceDir sourceFile: $sourceFile '
        'outputDir: $outputDir outputFile: $outputFile';
  }
}

Future<void> handleLangFiles(GenerateOptions options) async {
  final current = Directory.current;
  final source = Directory.fromUri(Uri.parse(options.sourceDir));
  final output = Directory.fromUri(Uri.parse(options.outputDir));
  final sourcePath = Directory(path.join(current.path, source.path));
  final outputPath =
      Directory(path.join(current.path, output.path, options.outputFile));

  if (!sourcePath.existsSync()) {
    printError('Source path does not exist');
    return;
  }

  var files = await dirContents(sourcePath);
  if (options.sourceFile != null) {
    final sourceFile = File(path.join(source.path, options.sourceFile));
    if (!sourceFile.existsSync()) {
      printError('Source file does not exist (${sourceFile.toString()})');
      return;
    }
    files = [sourceFile];
  } else {
    //filtering format
    files = files.where((f) => f.path.contains('.json')).toList();
  }

  if (files.isNotEmpty) {
    generateFile(files, outputPath, options.format);
  } else {
    printError('Source path empty');
  }
}

Future<List<FileSystemEntity>> dirContents(Directory dir) {
  final files = <FileSystemEntity>[];
  final completer = Completer<List<FileSystemEntity>>();
  dir.list().listen(files.add, onDone: () => completer.complete(files));
  return completer.future;
}

void generateFile(
  List<FileSystemEntity> files,
  Directory outputPath,
  String format,
) {
  final generatedFile = File(outputPath.path);
  if (!generatedFile.existsSync()) {
    generatedFile.createSync(recursive: true);
  }

  String? classBuilder;
  switch (format) {
    case 'json':
      classBuilder = '$_gFilePrefix${_writeJson(files)}}\n';
      break;
    case 'keys':
      final fileData = File(files.last.path).readAsStringSync();
      if (fileData.isNotEmpty) {
        classBuilder = '$_keysFilePrefix${_resolve(json.decode(fileData))}}\n';
      }
      break;
    default:
      printError('Format not support');
  }

  if (classBuilder != null) {
    generatedFile.writeAsStringSync(classBuilder);
    printInfo('All done! File generated in ${outputPath.path}');
  }
}

String _resolve(Map<String, dynamic> translations, [String? accKey]) {
  String capitalize(String text) =>
      '${text[0].toUpperCase()}${text.substring(1)}';

  final fileContent = StringBuffer();
  final sortedKeys = translations.keys.toList();
  for (final key in sortedKeys) {
    final keyItem = translations[key];
    if (keyItem is Map<String, dynamic>) {
      final text = _resolve(
        translations[key],
        accKey != null ? '$accKey.$key' : key,
      );

      fileContent.write(text.startsWith('\n') ? text : '\n$text');
    }

    if (!_preservedKeywords.contains(key)) {
      final keyWords = key.split('_');
      if (accKey != null) {
        final newKey = keyWords.map(capitalize).join();
        final accKeyWords = [
          for (final key in accKey.split('.')) ...key.split('_')
        ];

        final newAccKey =
            accKeyWords.first + accKeyWords.sublist(1).map(capitalize).join();

        fileContent.writeln(
          """\tstatic const String $newAccKey$newKey = '$accKey.$key';""",
        );
      } else {
        final newKey =
            keyWords.first + keyWords.sublist(1).map(capitalize).join();
        fileContent.writeln("\tstatic const String $newKey = '$key';");
      }
    }
  }

  return fileContent.toString();
}

String _writeJson(List<FileSystemEntity> files) {
  final gFile = StringBuffer();

  const encoder = JsonEncoder.withIndent('  ');

  final listLocales = [];

  for (final file in files) {
    final localeName =
        path.basename(file.path).replaceFirst('.json', '').replaceAll('-', '_');
    listLocales.add('"$localeName": $localeName');
    final fileData = File(file.path);

    final data = json.decode(fileData.readAsStringSync());

    final mapString = encoder.convert(data);
    gFile.writeln('static const Map<String,dynamic> $localeName = $mapString;');
  }

  gFile.write(
    'static const Map<String, Map<String,dynamic>> '
    'mapLocales = {${listLocales.join(', ')}};',
  );
  return gFile.toString();
}

void printInfo(String info) =>
    print('\u001b[32measy localization: $info\u001b[0m');

void printError(String error) =>
    print('\u001b[31m[ERROR] easy localization: $error\u001b[0m');
