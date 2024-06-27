import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/filtering/filtering_modes.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/create_tags_dialog.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/dialogs/error_dialogs.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/tags_list/tag_tree_widget.dart';

class TagsPaneWidget extends StatelessWidget {
  final FilteringModes filteringMode;
  final Set<String> filters;
  final Function(TagEntity, bool) onTagSelected;
  final Function(List<TagEntity>) onSelectAllFilters;
  final Function() onUnselectAllFilters;
  final Function() onDisableFiltering;
  final String searchQuery;
  final Function(List<TagEntity>) onLoadAllTags;

  const TagsPaneWidget({
    super.key,
    required this.filteringMode,
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
          showErrorDialog(context, state.failure, filteringMode,
              filters.toList(), searchQuery);
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
              filteringMode != FilteringModes.someTagged &&
                  filteringMode == FilteringModes.allTagged &&
                  state.tags.isNotEmpty,
              filteringMode != FilteringModes.someTagged &&
                  filteringMode == FilteringModes.allUntagged &&
                  state.tags.isNotEmpty,
              filteringMode != FilteringModes.someTagged &&
                      filteringMode == FilteringModes.all ||
                  state.tags.isEmpty,
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
                        onPressed: () async {
                          final tags =
                              await showCreateTagsDialog(context, state.tags);
                          if (context.mounted &&
                              tags != null &&
                              tags.isNotEmpty) {
                            context
                                .read<TagBloc>()
                                .add(CreateTagsEvent(tags: tags));
                          }
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
                                existingTagsNames:
                                    state.tags.map((tag) => tag.name).toList(),
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
