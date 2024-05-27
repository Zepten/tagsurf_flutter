import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/file_widget.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/tag_widget.dart';

class FileExplorer extends StatelessWidget {
  const FileExplorer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Tagsurf',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      actions: [
        IconButton(
            onPressed: () {},
            tooltip: 'Поиск',
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            )),
        IconButton(
          onPressed: () async => await _pickFile(context),
          tooltip: 'Добавить файлы в Tagsurf',
          icon: const Icon(Icons.add_circle, color: Colors.black),
        ),
      ],
      backgroundColor: Colors.blue[100],
    );
  }

  _buildFilesList() {
    return BlocBuilder<FileBloc, FileState>(
      builder: (_, state) {
        if (state is FileLoadingState) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is FilesLoadedState) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return FileWidget(file: state.files[index]);
            },
            itemCount: state.files.length,
          );
        }
        return const SizedBox();
      },
    );
  }

  _buildTagsList() {
    return BlocBuilder<TagBloc, TagState>(
      builder: (_, state) {
        if (state is TagLoadingState) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is TagsLoadedState) {
          return ListView.builder(
            itemBuilder: (context, index) {
              if (index == 0) {
                return TextButton(
                    onPressed: () =>
                        context.read<FileBloc>().add(GetTrackedFilesEvent()),
                    child: const Text('Все'));
              } else if (index == 1) {
                return TextButton(
                    onPressed: () =>
                        context.read<FileBloc>().add(GetUntaggedFilesEvent()),
                    child: const Text('Без тегов'));
              } else {
                final tagIndex = index - 2;
                return TagWidget(tag: state.tags[tagIndex]);
              }
            },
            itemCount: state.tags.length + 2,
          );
        }
        return const SizedBox();
      },
    );
  }

  _buildBody() {
    const double tagsListWidth = 300;

    return Row(
      children: [
        SizedBox(width: tagsListWidth, child: _buildTagsList()),
        const VerticalDivider(
          width: 1,
          thickness: 1,
        ),
        Expanded(child: _buildFilesList()),
      ],
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    FileBloc fileBloc = context.read<FileBloc>();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true, dialogTitle: 'Добавить файлы в Tagsurf');
    if (result != null && result.files.isNotEmpty) {
      final files =
          result.files.map((file) => FileEntity(path: file.path!)).toList();
      fileBloc.add(TrackFilesEvent(files: files));
    }
  }
}
