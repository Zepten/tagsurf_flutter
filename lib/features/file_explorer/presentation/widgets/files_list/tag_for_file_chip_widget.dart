import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/config/util/color_code.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

class TagForFileChipWidget extends StatelessWidget {
  final FileEntity file;
  final TagEntity tag;

  final Set<String> filters;
  final Function(TagEntity, bool) onTagSelected;

  const TagForFileChipWidget({
    super.key,
    required this.file,
    required this.tag,
    required this.filters,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = filters.contains(tag.name);
    return RawChip(
      elevation: 5.0,
      shadowColor: isSelected ? Colors.blue : Colors.black,
      avatar: Icon(Icons.sell,
          color: getContrastColorFromColorCode(tag.colorCode)),
      label: Text(tag.name,
          style: TextStyle(
            color: getContrastColorFromColorCode(tag.colorCode),
            overflow: TextOverflow.ellipsis,
          )),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      side: BorderSide(
        color: isSelected ? Colors.blue : Colors.transparent,
        width: 2.0,
      ),
      deleteIcon: const Icon(
        Icons.remove_circle,
        size: 15.0,
      ),
      deleteIconColor: Colors.red[300],
      deleteButtonTooltipMessage: 'Убрать тег',
      onPressed: () {
        onTagSelected(tag, !isSelected);
      },
      onDeleted: () {
        context
            .read<TagBloc>()
            .add(UnlinkFileAndTagEvent(file: file, tagName: tag.name));
      },
      backgroundColor: getLightShadeFromColorCode(tag.colorCode),
    );
  }
}
