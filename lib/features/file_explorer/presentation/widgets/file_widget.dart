import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/file/file_bloc.dart';

class FileWidget extends StatelessWidget {
  final FileEntity? file;

  const FileWidget({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
        children: [
          Text(file!.path!),
          IconButton(
            icon: const Icon(Icons.remove_circle),
            color: Colors.blue,
            onPressed: () {
              context.read<FileBloc>().add(UntrackFileEvent(file!));
            },
          ),
        ],
      ),
    );
  }
}
