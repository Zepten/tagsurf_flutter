import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/config/constants/sort_by.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/app_bar_widget.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/files_list/files_pane_widget.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/tags_list/tags_pane_widget.dart';

class FileExplorer extends StatefulWidget {
  const FileExplorer({super.key});

  @override
  State<StatefulWidget> createState() => _FileExplorerState();
}

class _FileExplorerState extends State<FileExplorer>
    with WidgetsBindingObserver {
  late double tagsListWidth;
  final double minTagsListWidth = 250;
  late double maxTagsListWidth;

  Set<String> filters = {};
  bool isFiltering = false;
  String _searchQuery = '';
  List<String> _allTags = List.empty();
  SortBy sortBy = SortBy.dateAddedDesc;

  @override
  void initState() {
    super.initState();
    tagsListWidth = 300;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final double screenWidth = MediaQuery.of(context).size.width;
    maxTagsListWidth = max(minTagsListWidth, screenWidth / 2.5);
    tagsListWidth = tagsListWidth.clamp(minTagsListWidth, maxTagsListWidth);
  }

  @override
  void didChangeMetrics() {
    final double screenWidth = MediaQuery.of(context).size.width;
    maxTagsListWidth = max(minTagsListWidth, screenWidth / 2.5);
    setState(() {
      tagsListWidth = tagsListWidth.clamp(minTagsListWidth, maxTagsListWidth);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void reloadFiles() {
    print(
        'isFiltering: $isFiltering, filters: $filters, search: $_searchQuery');
    context.read<FileBloc>().add(GetFilesEvent(
        isFiltering: isFiltering,
        filters: filters.toList(),
        searchQuery: _searchQuery));
  }

  void updateFilters(TagEntity tag, bool isSelected) {
    setState(() {
      if (isSelected) {
        filters.add(tag.name);
      } else {
        filters.remove(tag.name);
      }
      isFiltering = true;
      reloadFiles();
    });
  }

  void selectAllFilters(List<TagEntity> tags) {
    setState(() {
      isFiltering = true;
      filters.addAll(tags.map((tag) => tag.name).toList());
    });
    reloadFiles();
  }

  void unselectAllFilters() {
    setState(() {
      isFiltering = true;
      filters.clear();
    });
    reloadFiles();
  }

  void disableFiltering() {
    setState(() {
      isFiltering = false;
      filters.clear();
    });
    reloadFiles();
  }

  void searchForFiles(String searchQuery) {
    setState(() {
      _searchQuery = searchQuery;
    });
    reloadFiles();
  }

  void updateAllTags(List<TagEntity> allTags) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _allTags = allTags.map((tag) => tag.name).toList();
      });
    });
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 14))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, isFiltering, filters.toList(), _searchQuery),
      body: Row(
        children: [
          // Список тегов
          SizedBox(
            width: tagsListWidth,
            child: TagsPaneWidget(
              isFiltering: isFiltering,
              filters: filters,
              onTagSelected: updateFilters,
              onSelectAllFilters: selectAllFilters,
              onUnselectAllFilters: unselectAllFilters,
              onDisableFiltering: disableFiltering,
              searchQuery: _searchQuery,
              onLoadAllTags: updateAllTags,
            ),
          ),
          GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                tagsListWidth += details.delta.dx;
                tagsListWidth =
                    tagsListWidth.clamp(minTagsListWidth, maxTagsListWidth);
              });
            },
            child: const MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: VerticalDivider(
                width: 10,
                thickness: 1,
                color: Colors.blue,
              ),
            ),
          ),
          // Список файлов
          FilesPaneWidget(
            isFiltering: isFiltering,
            filters: filters,
            onTagSelected: updateFilters,
            onSearch: searchForFiles,
            searchQuery: _searchQuery,
            allTags: _allTags,
          ),
        ],
      ),
    );
  }
}
