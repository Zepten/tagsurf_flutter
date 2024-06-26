import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/filtering/filtering_modes.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/search_query_formatter.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/error_dialogs.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/files_list/file_widget.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/util/pick_file.dart';

class FilesPaneWidget extends StatelessWidget {
  final FilteringModes filteringMode;
  final Set<String> filters;
  final Function(TagEntity, bool) onTagSelected;
  final Function(String) onSearch;
  final String searchQuery;
  final List<String> allTags;

  const FilesPaneWidget({
    super.key,
    required this.filteringMode,
    required this.filters,
    required this.onTagSelected,
    required this.onSearch,
    required this.searchQuery,
    required this.allTags,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Поиск файлов',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      onSearch(value);
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                Tooltip(
                  message: 'Сортировать по имени',
                  child: IconButton(
                    icon: const Icon(
                      Icons.sort_by_alpha,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      // TODO: sort files by name
                    },
                  ),
                ),
                Tooltip(
                  message: 'Сортировать по дате',
                  child: IconButton(
                    icon: const Icon(Icons.date_range, color: Colors.blue),
                    onPressed: () {
                      // TODO: sort files by date
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocListener<FileBloc, FileState>(
              listenWhen: (previous, current) => current is FilesErrorState,
              listener: (context, state) {
                if (state is FilesErrorState) {
                  showErrorDialog(context, state.failure, filteringMode,
                      filters.toList(), searchQuery);
                }
              },
              child: BlocBuilder<FileBloc, FileState>(
                builder: (_, state) {
                  if (state is FilesLoadingState) {
                    return const Center(
                      key: ValueKey('files_loading'),
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  if (state is FilesLoadedState) {
                    if (state.files.isNotEmpty) {
                      return ListView.builder(
                        key: ValueKey(state.files),
                        itemBuilder: (context, index) {
                          return FileWidget(
                            key: ValueKey(state.files[index].path),
                            file: state.files[index],
                            filteringMode: filteringMode,
                            filters: filters,
                            onTagSelected: onTagSelected,
                            searchQuery: searchQuery,
                            allTags: allTags,
                          );
                        },
                        itemCount: state.files.length,
                      );
                    } else {
                      // TODO: "Добавьте файлы"
                      String infoText;
                      final isSearchQueryEmpty =
                          SearchQueryFormatter.format(searchQuery).isEmpty;
                      switch (filteringMode) {
                        case FilteringModes.all:
                          if (searchQuery.isEmpty) {
                            infoText = 'Добавьте файлы в Tagsurf';
                          } else {
                            infoText = 'Файлы не найдены по запросу';
                          }
                          break;
                        case FilteringModes.someTagged:
                          infoText =
                              'Файлы с указанными тегами не найдены${isSearchQueryEmpty ? '' : ' по запросу'}';
                          break;
                        case FilteringModes.allTagged:
                          infoText =
                              'Файлы с тегами не найдены${isSearchQueryEmpty ? '' : ' по запросу'}';
                          break;
                        case FilteringModes.allUntagged:
                          infoText =
                              'Файлы без тегов не найдены${isSearchQueryEmpty ? '' : ' по запросу'}';
                          break;
                      }
                      return Center(
                        key: const ValueKey('files_not_found'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            filteringMode == FilteringModes.all &&
                                    isSearchQueryEmpty
                                ? IconButton(
                                    onPressed: () async => await pickFile(
                                        context,
                                        filteringMode,
                                        filters.toList(),
                                        searchQuery),
                                    icon: const Icon(
                                      Icons.add_circle_rounded,
                                      color: Colors.blue,
                                      size: 64,
                                    ),
                                  )
                                : const Icon(
                                    Icons.search_off_outlined,
                                    color: Colors.grey,
                                    size: 64,
                                  ),
                            const SizedBox(height: 8),
                            Text(
                              infoText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: (filteringMode == FilteringModes.all &&
                                        isSearchQueryEmpty
                                    ? Colors.blue
                                    : Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                  return const SizedBox.shrink(
                    key: ValueKey('files_empty'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
