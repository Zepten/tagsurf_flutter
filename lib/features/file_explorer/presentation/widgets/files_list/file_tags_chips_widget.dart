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
                onDeleted: () {
                  sl
                      .get<FileTagBlocRepository>()
                      .unlinkFileAndTag(filePath: file.path, tagName: tag.name);
                  context.read<TagBloc>().add(GetTagsByFileEvent(file: file));
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
}
