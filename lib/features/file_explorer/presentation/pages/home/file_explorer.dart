import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/file_widget.dart';

class FileExplorer extends StatelessWidget {
  const FileExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: const Text(
        'Tagsurf',
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.blue[200],
    );
  }

  _buildBody() {
    return BlocBuilder<FileBloc, FileState>(
      builder: (_, state) {
        if (state is FileLoadingState) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is FileLoadedState) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return FileWidget(
                file: state.files![index],
              );
            },
            itemCount: state.files!.length,
          );
        }
        return const SizedBox();
      },
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    FileBloc fileBloc = context.read<FileBloc>();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true, dialogTitle: 'Добавить файлы в Tagsurf');
    if (result != null && result.files.isNotEmpty) {
      final files = result.files
          .map((file) => FileEntity(path: file.path))
          .toList(growable: false);
      fileBloc.add(TrackFilesEvent(files));
    }
  }

  _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async => await _pickFile(context),
      backgroundColor: Colors.blue,
      tooltip: 'Добавить файлы в Tagsurf',
      child: const Icon(Icons.add_circle),
    );
  }
}
