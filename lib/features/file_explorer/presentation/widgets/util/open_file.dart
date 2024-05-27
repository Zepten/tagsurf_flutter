import 'dart:io';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> openFile(String filePath) async {
  final fileUri = Uri.file(filePath);

  if (await canLaunchUrl(fileUri)) {
    final filePath = fileUri.toFilePath(windows: Platform.isWindows);
    launchUrlString('file://$filePath', mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not open file at path: $filePath'; // TODO: error message
  }
}
