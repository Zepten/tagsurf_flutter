import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/show_error_dialog.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/tags_list/tag_tree_widget.dart';

class TagsListWidget extends StatelessWidget {
  const TagsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagBloc, TagState>(
      buildWhen: (previous, current) => (current is! TagsForFileLoadingState &&
          current is! TagsForFileLoadedState),
      builder: (_, state) {
        if (state is TagsLoadingState) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is TagsLoadedState) {
          return Column(
            children: [
              Row(
                children: [
                  TextButton(
                      onPressed: () =>
                          context.read<FileBloc>().add(GetTrackedFilesEvent()),
                      child: const Text('Все')),
                  TextButton(
                      onPressed: () =>
                          context.read<FileBloc>().add(GetUntaggedFilesEvent()),
                      child: const Text('Без тегов')),
                ],
              ),
              Expanded(child: TagTreeWidget(tags: state.tags)),
            ],
          );
        }
        if (state is TagsErrorState) {
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
