import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/core/util/file_utils.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/confirmations/unlink_tag_confirmation.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/common/tag_context_menu.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/widgets/util/color_util.dart';
import 'package:tagsurf_flutter/features/file_explorer/presentation/bloc/tag/tag_bloc.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/file_entity.dart';
import 'package:tagsurf_flutter/features/file_explorer/domain/entities/tag_entity.dart';

class TagForFileChipWidget extends StatelessWidget {
  final FileEntity file;
  final TagEntity tag;

  final Set<String> filters;
  final Function(TagEntity, bool) onTagSelected;

  final List<String> existingTagsNames;

  const TagForFileChipWidget({
    super.key,
    required this.file,
    required this.tag,
    required this.filters,
    required this.onTagSelected,
    required this.existingTagsNames,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = filters.contains(tag.name);
    return GestureDetector(
      onSecondaryTapDown: (TapDownDetails details) {
        showTagContextMenu(context, details.globalPosition, tag, onTagSelected, existingTagsNames);
      },
      child: RawChip(
        elevation: 5.0,
        shadowColor: isSelected ? Colors.blue : Colors.black,
        avatar: Icon(Icons.sell, color: ColorUtil.getDarkShade(tag.color)),
        label: Text(tag.name,
            style: TextStyle(
              color: ColorUtil.getDarkShade(tag.color),
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
        deleteButtonTooltipMessage: 'Отвязать тег',
        onPressed: () {
          onTagSelected(tag, !isSelected);
        },
        onDeleted: () async {
          final shouldUnlink =
              await showTagUnlinkConfirmation(context, tag, file);
          if (context.mounted && shouldUnlink) {
            context
                .read<TagBloc>()
                .add(UnlinkFileAndTagEvent(file: file, tagName: tag.name));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                showCloseIcon: true,
                elevation: 10.0,
                content: Text(
                    'Удалена связь между тегом "${tag.name}" и файлом "${FileUtils.basename(file.path)}"'),
                backgroundColor: Colors.blue,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        backgroundColor: ColorUtil.getLightShade(tag.color),
      ),
    );
  }
}
