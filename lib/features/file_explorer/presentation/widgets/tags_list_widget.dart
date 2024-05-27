import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/tag_widget.dart';

class TagsListWidget extends StatelessWidget {
  const TagsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagBloc, TagState>(
      buildWhen: (previous, current) => current is TagsLoadedState,
      builder: (_, state) {
        if (state is TagsLoadingState) {
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
}
