import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/error_dialogs.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/files_list/tag_for_file_chip_widget.dart';

class FileTagsChipsWidget extends StatefulWidget {
  final FileEntity file;
  final bool isFiltering;
  final Set<String> filters;
  final Function(TagEntity, bool) onTagSelected;
  final String searchQuery;
  final List<String> allTags;

  const FileTagsChipsWidget({
    super.key,
    required this.file,
    required this.isFiltering,
    required this.filters,
    required this.onTagSelected,
    required this.searchQuery,
    required this.allTags,
  });

  @override
  State<FileTagsChipsWidget> createState() => _FileTagsChipsWidgetState();
}

class _FileTagsChipsWidgetState extends State<FileTagsChipsWidget> {
  bool isAddingTag = false;
  bool isFieldExpanded = false;
  final animationDuration = const Duration(milliseconds: 200);
  Timer animationTimer = Timer(Duration.zero, () {});

  void shrink() {
    setState(() {
      isFieldExpanded = false;
    });
    animationTimer = Timer(animationDuration, () {
      setState(() {
        isAddingTag = false;
      });
    });
  }

  @override
  void dispose() {
    if (animationTimer.isActive) {
      animationTimer.cancel();
    }
    isAddingTag = false;
    super.dispose();
  }

  @override
  void initState() {
    context.read<TagBloc>().add(GetTagsByFileEvent(file: widget.file));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TagBloc, TagState>(
      listenWhen: (previous, current) => current is TagsErrorState,
      listener: (context, state) {
        if (state is TagsErrorState) {
          showErrorDialog(context, state.failure, widget.isFiltering,
              widget.filters.toList(), widget.searchQuery);
        }
      },
      child: BlocBuilder<TagBloc, TagState>(
        buildWhen: (previous, current) =>
            (current is TagsForFileLoadingState &&
                    current.file == widget.file ||
                current is TagsForFileLoadedState &&
                    current.file == widget.file) &&
            (current is! TagsLoadingState && current is! TagsLoadedState),
        builder: (_, state) {
          if (state is TagsForFileLoadingState && state.file == widget.file) {
            return const Column(
              children: [
                RawChip(
                  label: Center(child: CupertinoActivityIndicator()),
                  backgroundColor: Colors.transparent,
                  side: BorderSide(
                    color: Colors.transparent,
                    width: 2.0,
                  ),
                ),
              ],
            );
          }
          if (state is TagsForFileLoadedState && state.file == widget.file) {
            return Wrap(
              key: ValueKey(state.tags),
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                // Tags chips
                ...state.tags.map((TagEntity tag) => TagForFileChipWidget(
                      key: ValueKey(tag),
                      file: widget.file,
                      tag: tag,
                      filters: widget.filters,
                      onTagSelected: widget.onTagSelected,
                    )),
                // Add tag button
                Focus(
                  onFocusChange: (hasFocus) {
                    if (!hasFocus) {
                      shrink();
                    }
                  },
                  child: AnimatedContainer(
                    duration: animationDuration,
                    width: isFieldExpanded ? 250 : 150,
                    curve: Curves.easeInOut,
                    child: RawChip(
                      key: const ValueKey('adding_tag_chip'),
                      elevation: 5.0,
                      shadowColor: Colors.black,
                      avatar: const Icon(Icons.add, color: Colors.blue),
                      label: isAddingTag
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.5, horizontal: 2.0),
                              child: Autocomplete<String>(
                                optionsBuilder: (textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return List.empty();
                                  }
                                  return widget.allTags.where(
                                    (String option) => option
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase()),
                                  );
                                },
                                fieldViewBuilder: (
                                  context,
                                  textEditingController,
                                  focusNode,
                                  onFieldSubmitted,
                                ) {
                                  return TextField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    autofocus: true,
                                    decoration: const InputDecoration.collapsed(
                                      hintText: '',
                                    ),
                                    onSubmitted: (value) {
                                      final newTagName = value.trim();
                                      if (newTagName.isNotEmpty) {
                                        context.read<TagBloc>().add(
                                            LinkOrCreateTagEvent(
                                                file: widget.file,
                                                tagName: newTagName));
                                        shrink();
                                      }
                                    },
                                  );
                                },
                                optionsViewBuilder:
                                    (context, onSelected, options) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: SizedBox(
                                        width: 300.0,
                                        height: 220.0,
                                        child: Material(
                                          elevation: 10.0,
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: ListView.separated(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            itemCount: options.length,
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return const Divider();
                                            },
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final tagItem =
                                                  options.elementAt(index);
                                              return ListTile(
                                                title: Text(tagItem,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14)),
                                                leading: const Icon(Icons.sell),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                onTap: () =>
                                                    onSelected(tagItem),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                onSelected: (selection) {
                                  context.read<TagBloc>().add(
                                        LinkOrCreateTagEvent(
                                          file: widget.file,
                                          tagName: selection,
                                        ),
                                      );
                                  shrink();
                                },
                              ),
                            )
                          : const Text(
                              'Добавить тег',
                              style: TextStyle(color: Colors.blue),
                            ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      side: const BorderSide(
                          color: Colors.transparent, width: 2.0),
                      backgroundColor: const Color.fromARGB(255, 235, 235, 255),
                      onPressed: () {
                        setState(() {
                          isAddingTag = true;
                          isFieldExpanded = true;
                        });
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
