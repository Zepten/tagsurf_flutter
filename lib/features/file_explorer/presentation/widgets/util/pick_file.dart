import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/filtering/filtering_modes.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';

Future<void> pickFile(
  BuildContext context,
  FilteringModes filteringMode,
  List<String> filters,
  String searchQuery,
) async {
  FileBloc fileBloc = context.read<FileBloc>();
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      dialogTitle: 'Добавить файлы в Tagsurf',
      lockParentWindow: true);
  if (result != null && result.files.isNotEmpty) {
    final files = result.files
        .map((file) => FileEntity(
              path: file.path!,
              dateTimeAdded: DateTime.now(),
            ))
        .toList();
    fileBloc.add(TrackFilesEvent(
        files: files,
        filteringMode: filteringMode,
        filters: filters,
        searchQuery: searchQuery));
  }
}
