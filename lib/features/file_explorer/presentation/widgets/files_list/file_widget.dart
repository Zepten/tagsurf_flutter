import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/search_query_formatter.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/file/file_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/files_list/file_tags_chips_widget.dart';

class FileWidget extends StatelessWidget {
  final FileEntity file;
  final bool isFiltering;
  final Set<String> filters;
  final Function(TagEntity, bool) onTagSelected;
  final String searchQuery;
  final List<String> allTags;

  const FileWidget({
    super.key,
    required this.file,
    required this.isFiltering,
    required this.filters,
    required this.onTagSelected,
    required this.searchQuery,
    required this.allTags,
  });

  TextSpan _highlightTextBySearchQuery(String text) {
    final query = SearchQueryFormatter.format(searchQuery);
    if (searchQuery.isEmpty || !text.toLowerCase().contains(query)) {
      return TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      );
    }

    final indexOfHighlight = text.toLowerCase().indexOf(query);

    return TextSpan(
      children: [
        TextSpan(
          text: text.substring(0, indexOfHighlight),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        TextSpan(
          text:
              text.substring(indexOfHighlight, indexOfHighlight + query.length),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            backgroundColor: Colors.yellow,
          ),
        ),
        TextSpan(
          text: text.substring(indexOfHighlight + query.length),
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 50),
      child: Card(
        margin: const EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail placeholder
              const Icon(
                Icons.insert_drive_file,
                size: 45.0,
                color: Colors.blue,
              ),
              // Расстояние между thumbnail и информацией о файле
              const SizedBox(width: 16.0),
              // Информация о файле
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Название файла
                        RichText(
                          text: _highlightTextBySearchQuery(
                            FileUtils.basename(file.path),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Расстояние между названием файла и его путем
                        const SizedBox(height: 2),
                        // Путь к файлу
                        Text(
                          file.path,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    // Расстояние между информацией о файле и панелью тегов
                    const SizedBox(height: 16.0),
                    // Панель тегов файла
                    FileTagsChipsWidget(
                      key: ValueKey(file.path),
                      file: file,
                      isFiltering: isFiltering,
                      filters: filters,
                      onTagSelected: onTagSelected,
                      searchQuery: searchQuery,
                      allTags: allTags,
                    ),
                  ],
                ),
              ),
              // Кнопка открытия файла
              IconButton(
                icon: const Icon(Icons.open_in_new, color: Colors.blue),
                tooltip: 'Открыть файл',
                onPressed: () {
                  context.read<FileBloc>().add(OpenFileEvent(file: file));
                },
              ),
              // Кнопка добавления в избранное
              IconButton(
                icon: const Icon(Icons.favorite_outline_sharp,
                    color: Colors.blue),
                tooltip: 'Добавить в Избранное',
                onPressed: () {
                  const AboutDialog();
                },
              ),
              // Кнопка удаления файла
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.blue),
                tooltip: 'Убрать файл',
                onPressed: () {
                  context.read<FileBloc>().add(UntrackFilesEvent(
                      files: [file],
                      isFiltering: isFiltering,
                      filters: filters.toList(),
                      searchQuery: searchQuery));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
