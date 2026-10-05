import 'dart:io';

void main() {
  final dir = Directory(r'e:\project\kiddo\lib');
  
  if (!dir.existsSync()) return;

  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    bool changed = false;

    if (content.contains("import 'package:flutter_gen/gen_l10n/app_localizations.dart';")) {
      content = content.replaceAll("import 'package:flutter_gen/gen_l10n/app_localizations.dart';", "import 'package:kiddo/l10n/app_localizations.dart';");
      changed = true;
    }
    
    if (content.contains("AppLocalizations.of(context)!.")) {
      content = content.replaceAll("AppLocalizations.of(context)!.", "AppLocalizations.of(context).");
      changed = true;
    }
    
    // Some uses might just be AppLocalizations.of(context)! (e.g. at end of line or without .)
    if (content.contains("AppLocalizations.of(context)!")) {
      content = content.replaceAll("AppLocalizations.of(context)!", "AppLocalizations.of(context)");
      changed = true;
    }

    if (changed) {
      file.writeAsStringSync(content);
      print('Updated \${file.path}');
    }
  }
  print('Done.');
}
