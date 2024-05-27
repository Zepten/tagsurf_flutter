import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/file_widget.dart';

class FilesListWidget extends StatelessWidget {
  const FilesListWidget({super.key});

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
        return const SizedBox();
      },
    );
  }
}
