import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/show_error_dialog.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/tag_for_file_chip_widget.dart';

class FileTagsChipsWidget extends StatelessWidget {
  final FileEntity file;

  const FileTagsChipsWidget({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    // Trigger loading of tags whenever the widget is built
    context.read<TagBloc>().add(GetTagsByFileEvent(file: file));
    return BlocBuilder<TagBloc, TagState>(
      buildWhen: (previous, current) =>
          (current is TagsForFileLoadedState && current.file == file) &&
          (current is! TagsLoadingState && current is! TagsLoadedState),
      builder: (_, state) {
        if (state is TagsForFileLoadingState) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is TagsForFileLoadedState && state.file == file) {
          final tags = state.tags;
          return Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              // Tags chips
              ...tags.map(
                  (TagEntity tag) => TagOfFileChipWidget(file: file, tag: tag)),
              // Add tag button
              RawChip(
                avatar: const Icon(Icons.add, color: Colors.blue),
                label: const Text(
                  'Добавить тег',
                  style: TextStyle(color: Colors.blue),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                side: const BorderSide(color: Colors.transparent),
                backgroundColor: const Color.fromARGB(255, 235, 235, 255),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) => AlertDialog(
                      title: const Text('Добавить тег'),
                      content: TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Название тега',
                            border: OutlineInputBorder()),
                        onFieldSubmitted: (value) {
                          final newTagName = value.trim();
                          if (newTagName.isNotEmpty) {
                            context.read<TagBloc>().add(LinkOrCreateTagEvent(
                                file: file, tagName: newTagName));
                            Navigator.of(dialogContext).pop();
                          }
                        },
                      ),
                    ),
                  );
                },
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
