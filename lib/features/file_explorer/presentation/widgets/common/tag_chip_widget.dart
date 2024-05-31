import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/config/util/color_code.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

class TagChipWidget extends StatelessWidget {
  final TagEntity tag;
  final bool isSelected;
  final Function(TagEntity, bool) onTagSelected;

  const TagChipWidget(
      {super.key,
      required this.tag,
      required this.isSelected,
      required this.onTagSelected});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(tag.name,
          style: TextStyle(
            color: getContrastColorFromColorCode(tag.colorCode),
          )),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      side: const BorderSide(
        color: Colors.transparent,
      ),
      selected: isSelected,
      selectedShadowColor:
          getLightShadeFromColorCode(tag.colorCode).withOpacity(0.5),
      onSelected: (bool value) {
        onTagSelected(tag, value);
      },
      backgroundColor: getLightShadeFromColorCode(tag.colorCode),
    );
  }
}

class TagOfFileChipWidget extends StatelessWidget {
  final FileEntity file;
  final TagEntity tag;

  const TagOfFileChipWidget({super.key, required this.file, required this.tag});

  @override
  Widget build(BuildContext context) {
    return RawChip(
      avatar:
          Icon(Icons.sell, color: getContrastColorFromColorCode(tag.colorCode)),
      label: Text(tag.name,
          style: TextStyle(
            color: getContrastColorFromColorCode(tag.colorCode),
          )),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      side: const BorderSide(
        color: Colors.transparent,
      ),
      deleteIcon: const Icon(
        Icons.remove_circle,
        size: 15.0,
      ),
      deleteIconColor: Colors.red[300],
      deleteButtonTooltipMessage: 'Убрать тег',
      onPressed: () {
        // TODO: select
        //context.read<FileBloc>().add(GetFilesByTagEvent(tag: tag));
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
