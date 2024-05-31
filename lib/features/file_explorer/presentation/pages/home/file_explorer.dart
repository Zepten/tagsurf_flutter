import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final double minTagsListWidth = 200;
  late double maxTagsListWidth;

  Set<TagEntity> filters = {};
  bool isFiltering = false;

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
    maxTagsListWidth = max(minTagsListWidth, screenWidth / 3);
    tagsListWidth = tagsListWidth.clamp(minTagsListWidth, maxTagsListWidth);
  }

  @override
  void didChangeMetrics() {
    final double screenWidth = MediaQuery.of(context).size.width;
    maxTagsListWidth = max(minTagsListWidth, screenWidth / 3);
    setState(() {
      tagsListWidth = tagsListWidth.clamp(minTagsListWidth, maxTagsListWidth);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void updateFilters(TagEntity tag, bool isSelected) {
    setState(() {
      if (isSelected) {
        filters.add(tag);
      } else {
        filters.remove(tag);
      }
      context.read<FileBloc>().add(GetFilesByTagsEvent(tags: filters.toList()));
    });
  }

  void selectAllFilters(List<TagEntity> tags) {
    setState(() {
      filters.addAll(tags);
    });
    context.read<FileBloc>().add(GetFilesByTagsEvent(tags: filters.toList()));
  }

  void resetFilters() {
    setState(() {
      filters.clear();
    });
    context.read<FileBloc>().add(GetUntaggedFilesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Row(
        children: [
          // Список тегов
          SizedBox(
            width: tagsListWidth,
            child: TagsPaneWidget(
              filters: filters,
              onTagSelected: updateFilters,
              onSelectAllFilters: selectAllFilters,
              onResetFilters: resetFilters,
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
                color: Colors.grey,
              ),
            ),
          ),
          // Список файлов
          const Expanded(child: FilesPaneWidget()),
        ],
      ),
    );
  }
}
