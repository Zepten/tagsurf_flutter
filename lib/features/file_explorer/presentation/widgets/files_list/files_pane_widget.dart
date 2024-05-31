import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/show_error_dialog.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/files_list/file_widget.dart';

class FilesPaneWidget extends StatelessWidget {
  const FilesPaneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      builder: (_, state) {
        if (state is FilesLoadingState) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is FilesLoadedState) {
          return ListView.builder(
            itemBuilder: (_, index) {
              return FileWidget(file: state.files[index]);
            },
            itemCount: state.files.length,
          );
        }
        if (state is FilesErrorState) {
          showErrorDialog(context, state.failure);
          return const Center(
            child: Icon(Icons.error, color: Colors.red, size: 50),
          );
        }
        return const SizedBox();
      },
    );
  }
}
