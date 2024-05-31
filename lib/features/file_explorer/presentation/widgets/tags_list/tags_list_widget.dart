import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/show_error_dialog.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/tags_list/tag_tree_widget.dart';

class TagsListWidget extends StatelessWidget {
  final Set<TagEntity> filters;
  final Function(TagEntity, bool) onTagSelected;
  final Function(List<TagEntity>) onSelectAllFilters;
  final Function() onResetFilters;

  const TagsListWidget(
      {super.key,
      required this.filters,
      required this.onTagSelected,
      required this.onSelectAllFilters,
      required this.onResetFilters});

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
                    onPressed: () => onSelectAllFilters(state.tags),
                    child: const Text('Выбрать всё'),
                  ),
                  TextButton(
                    onPressed: () => onResetFilters(),
                    child: const Text('Без тегов'),
                  ),
                ],
              ),
              TagTreeWidget(
                tags: state.tags,
                filters: filters,
                onTagSelected: onTagSelected,
              ),
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
