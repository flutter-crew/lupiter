import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart';

// ignore_for_file: sort_constructors_first

ArgParser get _parser {
  return ArgParser()
    ..addOption(
      'source-dir',
      abbr: 's',
      defaultsTo: 'assets',
      help: 'The path to assets folder.',
    )
    ..addOption(
      'output-file',
      abbr: 'o',
      defaultsTo: 'lib/codegen_assets.g.dart',
      help: 'Output file path (with name).',
    )
    ..addOption(
      'class-name',
      abbr: 'c',
      defaultsTo: 'CodeGenAssets',
      help: 'Use a valid DartClassName.',
    )
    ..addMultiOption(
      'exclude',
      abbr: 'e',
      help: 'Exclude files or folders with a regex match. '
          'Input separated by comma.',
    )
    ..addFlag(
      'import-comments',
      abbr: 'i',
      defaultsTo: true,
      help: 'The flag that switches adding import comments '
          'in the generated file.',
    );
}

Future<void> main(List<String> args) async {
  /// Show help.
  if (args.length == 1 && (args.first == '--help' || args.first == '-h')) {
    return stdout.write(_parser.usage);
  }

  /// Generate options from [_parser].
  final options = Options.fromParser(_parser.parse(args));

  /// Get all files from [Options.sourceDir] folder.
  final files = List<File>.empty(growable: true);
  listing:
  await for (final entity in options.sourceDir.list(recursive: true)) {
    if (entity is File) {
      /// Whitelist files with [Options.exclude] patterns.
      for (final regex in options.exclude) {
        if (regex.hasMatch(entity.path)) {
          continue listing;
        }
      }
      files.add(entity);
    }
  }

  /// Sort source dir first and every other dir after that.
  files.sort((a, b) {
    if (b.parent.path == options.sourceDir.path) {
      return basename(a.path).toLowerCase().compareTo(
            basename(b.path).toLowerCase(),
          );
    } else {
      return a.parent.path.compareTo(b.parent.path).compareTo(
            basename(a.path).toLowerCase().compareTo(
                  basename(b.path).toLowerCase(),
                ),
          );
    }
  });

  /// Add initial Generator message.
  final output = StringBuffer(
    '''
/// Copyright (C) 2021 by original author @ fluttercrew
/// This file was generated with FlutterCrew Assets Generator.
''',
  );

  /// Add import comments.
  if (options.importComments && files.isNotEmpty) {
    output.write(
      '''
///
/// To use this, include the following in your pubspec.yaml:
///
/// flutter:
///   assets:
''',
    );
    for (final file in files) {
      final path = file.path
          .replaceFirst(Directory.current.path, '')
          .replaceAll(r'\', '/');
      output.writeln('///     - $path');
    }
  }

  /// Add [Options.className] header and lint ignore rules.
  output.write(
    '''
\n// ignore_for_file: public_member_api_docs, lines_longer_than_80_chars

abstract class ${options.className} {${files.isNotEmpty ? '\n' : ''}''',
  );

  String formatLine(String path) {
    /// Get the file path without extension.
    final sourcePath = path

        /// Get the full relative path
        .replaceFirst(Directory.current.path, '')

        /// Format backslash to slashes if any.
        .replaceAll(r'\', '/');

    final keyName =

        /// Get the path without extension.
        withoutExtension(sourcePath)

            /// Remove the source dir path from path.
            .replaceFirst(basename(options.sourceDir.path), '')

            /// Get the start of the text path.
            .replaceFirst(RegExp('[/_]+'), '')

            /// Split on join symbols and format camelCase.
            .splitMapJoin(
              RegExp('[/_]+.'),
              onMatch: (m) => m[0]!.substring(m[0]!.length - 1).toUpperCase(),
            )

            /// Replace any special symbols.
            .replaceAll(RegExp('[^a-zA-Z0-9]+'), '');
    return "\tstatic const String $keyName = '$sourcePath';";
  }

  /// Add a record for every matched file.
  Directory? _previousDirectory;
  for (final file in files) {
    if (_previousDirectory?.path != file.parent.path &&
        file.parent.path != options.sourceDir.path) {
      if (files.indexOf(file) > 0) {
        output.writeln();
      }
      _previousDirectory = file.parent;
      output.writeln(formatLine(_previousDirectory.path));
    }
    output.writeln(formatLine(file.path));
  }

  /// Close the class.
  output.writeln('}');

  /// Write the [output] to the [Options.outputFile].
  options.outputFile.writeAsStringSync(output.toString());
}

/// The class to store this generator options.
class Options {
  /// The class to store this generator options.
  Options({
    required this.sourceDir,
    required this.outputFile,
    required this.className,
    this.exclude = const <RegExp>{},
    this.importComments = true,
  })  : assert(!sourceDir.existsSync(), 'Source path does not exist'),
        assert(className.isNotEmpty, 'class name can not be empty');

  /// The path to assets folder.
  final Directory sourceDir;

  /// The path to save file.
  final File outputFile;

  /// The name of the generated class.
  final String className;

  /// The list of regex matches to exclude.
  final Iterable<RegExp> exclude;

  /// The flag to whether to show comments on files import.
  final bool importComments;

  Options.fromParser(ArgResults results)
      : sourceDir = Directory(results['source-dir']),
        outputFile = File(results['output-file']),
        className = results['class-name'],
        exclude = (results['exclude'] as Iterable<String>)
            .map((e) => RegExp(e))
            .cast<RegExp>(),
        importComments = results['import-comments'];
}
