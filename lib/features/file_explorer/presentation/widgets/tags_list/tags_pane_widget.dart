import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/error_dialogs.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/tags_list/tag_tree_widget.dart';

class TagsPaneWidget extends StatelessWidget {
  final bool isFiltering;
  final Set<String> filters;
  final Function(TagEntity, bool) onTagSelected;
  final Function(List<TagEntity>) onSelectAllFilters;
  final Function() onUnselectAllFilters;
  final Function() onDisableFiltering;
  final String searchQuery;
  final Function(List<TagEntity>) onLoadAllTags;

  const TagsPaneWidget({
    super.key,
    required this.isFiltering,
    required this.filters,
    required this.onTagSelected,
    required this.onSelectAllFilters,
    required this.onUnselectAllFilters,
    required this.onDisableFiltering,
    required this.searchQuery,
    required this.onLoadAllTags,
  });

  void _handleTagDropped(
      BuildContext context, TagEntity sourceTag, TagEntity targetTag) {
    context
        .read<TagBloc>()
        .add(SetParentTagEvent(tag: sourceTag, parentTag: targetTag));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TagBloc, TagState>(
      listenWhen: (previous, current) => current is TagsErrorState,
      listener: (context, state) {
        if (state is TagsErrorState) {
          showErrorDialog(context, state.failure, isFiltering, filters.toList(),
              searchQuery);
        }
      },
      child: BlocBuilder<TagBloc, TagState>(
        buildWhen: (previous, current) =>
            (current is! TagsForFileLoadingState &&
                current is! TagsForFileLoadedState),
        builder: (_, state) {
          if (state is TagsLoadingState) {
            return const Center(
              key: ValueKey('tags_loading'),
              child: CupertinoActivityIndicator(),
            );
          }
          if (state is TagsLoadedState) {
            onLoadAllTags(state.tags);
            List<bool> isSelected = [
              state.tags.isNotEmpty &&
                  isFiltering &&
                  setEquals(state.tags.map((tag) => tag.name).toSet(), filters),
              state.tags.isNotEmpty && isFiltering && filters.isEmpty,
              state.tags.isEmpty || !isFiltering,
            ];
            return Column(
              key: const ValueKey('tags_loaded'),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => {
                          // TODO: add new tag
                        },
                        icon: const Icon(Icons.add_circle_rounded,
                            color: Colors.blue),
                        tooltip: 'Создать тег',
                      ),
                      const Spacer(),
                      ToggleButtons(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                        borderColor: Colors.blue[200],
                        selectedBorderColor: Colors.blue[400],
                        fillColor: Colors.blue[100],
                        isSelected: isSelected,
                        onPressed: (index) {
                          switch (index) {
                            case 0:
                              if (state.tags.isNotEmpty) {
                                onSelectAllFilters(state.tags);
                              }
                              break;
                            case 1:
                              if (state.tags.isNotEmpty) {
                                onUnselectAllFilters();
                              }
                              break;
                            case 2:
                              if (state.tags.isNotEmpty) {
                                onDisableFiltering();
                              }
                              break;
                          }
                        },
                        children: [
                          Tooltip(
                            message: 'Показать все файлы с тегами',
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(Icons.done_all_rounded,
                                  color: Colors.blue),
                            ),
                          ),
                          Tooltip(
                            message: 'Показать все файлы без тегов',
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(Icons.remove_done_rounded,
                                  color: Colors.blue),
                            ),
                          ),
                          Tooltip(
                            message: 'Показать все файлы',
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(Icons.filter_alt_off_rounded,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: IntrinsicWidth(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TagTreeWidget(
                                key: const ValueKey('tag_tree_widget'),
                                tags: state.tags,
                                filters: filters,
                                onTagSelected: onTagSelected,
                                onTagDropped: _handleTagDropped,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          }
          return const SizedBox.shrink(
            key: ValueKey('tags_empty'),
          );
        },
      ),
    );
  }
}
