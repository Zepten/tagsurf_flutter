import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/config/util/color_code.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/common/file_tag_bloc_repository.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/file/file_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/injection_container.dart';

class FileTagsChipsWidget extends StatelessWidget {
  final FileEntity file;

  const FileTagsChipsWidget({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    // Trigger loading of tags whenever the widget is built
    context.read<TagBloc>().add(GetTagsByFileEvent(file: file));
    return BlocBuilder<TagBloc, TagState>(
      buildWhen: (previous, current) =>
          (current is TagsForFileLoadedState && current.file == file),
      builder: (_, state) {
        if (state is TagsForFileLoadingState) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state is TagsForFileLoadedState && state.file == file) {
          final tags = state.tags;
          return Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              // Tags chips
              ...tags.map((TagEntity tag) {
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
                    context.read<FileBloc>().add(GetFilesByTagEvent(tag: tag));
                    context.read<TagBloc>().add(GetAllTagsEvent());
                  },
                  onDeleted: () {
                    sl
                        .get<FileTagBlocRepository>()
                        .unlinkFileAndTag(file: file, tag: tag)
                        .then((_) => context
                            .read<TagBloc>()
                            .add(GetTagsByFileEvent(file: file)));
                  },
                  backgroundColor: getLightShadeFromColorCode(tag.colorCode),
                );
              }),
              // Add tag button
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Добавить тег'),
                      content: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Название тега',
                            border: OutlineInputBorder()),
                        onFieldSubmitted: (value) {
                          final tagName = value.trim();
                          if (tagName.isNotEmpty) {
                            final tag = TagEntity.fromDefaults(tagName);
                            // TODO FIX: Not updating automatically
                            sl
                                .get<FileTagBlocRepository>()
                                .linkOrCreateTag(file: file, tag: tag)
                                .then((_) => context
                                    .read<TagBloc>()
                                    .add(GetTagsByFileEvent(file: file)));
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
                tooltip: 'Добавить тег',
                icon: const Icon(Icons.add, color: Colors.blue),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
