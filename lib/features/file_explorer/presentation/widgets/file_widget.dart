import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tagsurf_flutter/config/util/color_code.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/common/file_tag_bloc_repository.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/injection_container.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FileWidget extends StatelessWidget {
  final FileEntity file;

  const FileWidget({super.key, required this.file});

  _openFile(String filePath) async {
    final fileUri = Uri.file(filePath);

    if (await canLaunchUrl(fileUri)) {
      final filePath = fileUri.toFilePath(windows: Platform.isWindows);
      launchUrlString('file://$filePath', mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open file at path: $filePath'; // TODO: error message
    }
  }

  _buildTagChipList(BuildContext context) {
    context.read<TagBloc>().add(GetTagsByFileEvent(file: file));
    return BlocBuilder<TagBloc, TagState>(
      buildWhen: (previous, current) =>
          current is TagsForFileLoadedState && current.file == file,
      builder: (_, state) {
        if (state is TagsForFileLoadingState) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is TagsForFileLoadedState && state.file == file) {
          final tags = state.tags;
          return Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: tags.map((TagEntity tag) {
              return RawChip(
                avatar: Icon(Icons.sell,
                    color: getContrastColorFromColorCode(tag.colorCode)),
                label: Text(tag.name,
                    style: TextStyle(
                        color: getContrastColorFromColorCode(tag.colorCode))),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                deleteButtonTooltipMessage: 'Убрать тег',
                onPressed: () {
                  context.read<TagBloc>().add(GetAllTagsEvent());
                  context.read<FileBloc>().add(GetFilesByTagEvent(tag: tag));
                },
                onDeleted: () async {
                  sl
                      .get<FileTagBlocRepository>()
                      .unlinkFileAndTag(file: file, tag: tag);
                },
                backgroundColor: getLightShadeFromColorCode(tag.colorCode),
              );
            }).toList(),
          );
        }
        return const SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TagBloc, TagState>(
      listenWhen: (previous, current) {
        return !(current is TagsForFileLoadedState && current.file == file);
      },
      listener: (context, state) {
        if (state is TagsForFileLoadedState && state.file == file) {
          context.read<TagBloc>().add(GetTagsByFileEvent(file: file));
        }
      },
      child: Container(
        margin: const EdgeInsets.all(12.0),
        child: GestureDetector(
          onDoubleTap: () => _openFile(file.path),
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
              const SizedBox(width: 10),
              // Информация о файле
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onDoubleTap: () => _openFile(file.path),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Название файла
                          Text(
                            FileUtils.basename(file.path),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
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
                    ),
                    // Расстояние между информацией о файле и панелью тегов
                    const SizedBox(height: 10),
                    _buildTagChipList(context),
                  ],
                ),
              ),
              // Кнопка добавления тега
              IconButton(
                icon: const Icon(Icons.add_box_rounded, color: Colors.blue),
                tooltip: 'Добавить теги',
                onPressed: () {
                  const AboutDialog();
                },
              ),
              // Кнопка добавления в избранное
              IconButton(
                icon: const Icon(Icons.favorite_outline_sharp, color: Colors.blue),
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
                  context.read<FileBloc>().add(UntrackFileEvent(file: file));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
